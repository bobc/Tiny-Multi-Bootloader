/* ---------------------------------------------------------------------------------------
 * PIC32 firmware for "Tiny Pic Bootloader +"
 *
 * This code was writen by Edorul (edorul@free.fr)
 * It can be downloaded at:
 *      https://sourceforge.net/projects/tinypicbootload/
 *
 * This software is under "Creative Commons Attribution Non-Commercial License":
 *  - you can use it at home free of charge
 *  - you can use it at work free of charge
 *  - you can share it free of charge, but this licence must remain the same
 *  - you can modify it as you want, but this licence must remain the same
 *  - you CAN'T sell it, even if you have modified it
 *
 * The idea and first realisation of "Tiny PIC Bootloader" is the work Claudiu Chiculita.
 * His web site is here:
 *      http://www.etc.ugal.ro/cchiculita/software/picbootloader.htm
 * It worth the look!
 * Thank a lot for this great work!!!
 *
 * Following functions come from "PIC32_bootloaders" Microchip's project:
 *  - void JumpToApp(void)
 *  - UINT __attribute__((nomips16)) NVMemOperation(UINT nvmop)
 *  - UINT NVMemWriteWord(void* address, UINT data)
 *  - UINT NVMemErasePage(void* address)
 * ---------------------------------------------------------------------------------------
 */

// legend:
//  o to do
//  ~ to test
//  x working
//
// v0.1-0.3:
//  x place bootloader in kseg1_boot_mem
//  x communicate with PC software
//
// v0.4: (must be used with "TinyPicBootloader v0.4")
//  x work with special ".ld" file used for Microchip HID Bootloader
//
// v0.5: (must be used with "TinyPicBootloader v0.5")
//  x when erasing send to PC number of pages to be erased, then send ack (BTLDR_ERASE) for each
//    erased page (in order to use progress bar in PC software). When finished send BTLDR_OK
//
// v0.6: (must be used with "TinyPicBootloader >= v0.6")
//  x place bootloader at the end of the flash program memory
//  x work with normal ".ld" file and with special ".ld" file used for Microchip HID Bootloader
//
// v0.6.1:
//  x bug fix: now erase program flash AND BOOT FLASH, as with PIC32: writing data on a non erased address
//    will write a random value (if writed data is different from the stored one, if it's the same then
//    write is OK).
//
// v0.7.0.2:
//  x changed "#pragma config FCKSM" to enble Clock Switching
//
// v0.7.1:
//  x USB CDC version of the firmware
//
// future:
//  o code "BOOL checkChkSum(BYTE chkSumReceived)" function
//  o use config bytes to calculate "SYST_CLOCK"
//
// remarks :
//  - BMXBOOTSZ gives boot flash size memory. On PIC32MX3xxto7xx family it is 0x3000 = 12KB
//    For PIC32MX1XX/2XX family it is only 3KB... so if bootloader size is superior
//    to 0x760, I must place bootloader in prog flash :-( and not in the
//    debug part of the boot flash (debug_exec_mem) as I wanted to do.

#include <p32xxxx.h>
#include <plib.h>
#include "main.h"

// ------------ NEED TO BE MODIFIED BY USER ---------------
//#define QUARTZ_FREQ	8000000  // Board Quartz frequency ### unused for the moment
#define SYST_CLOCK	80000000 // need to be calculated with QUARTZ_FREQ and configuration bits

#define PIC_CODE        0xD7     // if code doesn't exist in "piccodes.ini" file, you must create the chip
// --------------- END OF MODIFICATIONS -------------------

//   Part number defining Macro
#if   (((__PIC32_FEATURE_SET__ >= 100) && (__PIC32_FEATURE_SET__ <= 299)))
    #define __PIC32MX1XX_2XX__
#elif (((__PIC32_FEATURE_SET__ >= 300) && (__PIC32_FEATURE_SET__ <= 799)))
    #define __PIC32MX3XX_7XX__
#else
    #error("Controller not supported")
#endif

// PIC32 configuration bits
#if defined(__PIC32MX1XX_2XX__)
// ### todo
#elif defined(__PIC32MX3XX_7XX__)
    #pragma config UPLLEN   = ON            // USB PLL Enabled
    // Fréq USB (48MHz) = Fréq Quartz / UPLLIDIV * 24 / 2
    #pragma config UPLLIDIV = DIV_2         // USB PLL Input Divider
    // Fréq CPU (SYSCLK) = Fréq Quartz / FPLLIDIV * FPLLMUL / FPLLODIV
    #pragma config FPLLMUL  = MUL_20        // PLL Multiplier
    #pragma config FPLLIDIV = DIV_2         // PLL Input Divider
    #pragma config FPLLODIV = DIV_1         // PLL Output Divider
    // Fréq Périphériques (PBCLCK) = Fréq Quartz / FPLLIDIV * FPLLMUL / FPLLODIV / FPBDIV
    #pragma config FPBDIV   = DIV_1         // Peripheral Clock divisor
    #pragma config FWDTEN   = OFF           // Watchdog Timer
    #pragma config WDTPS    = PS1           // Watchdog Timer Postscale
    #pragma config FCKSM    = CSECMD        // Clock Switching Enabled & Fail Safe Clock Monitor Disabled
    #pragma config OSCIOFNC = OFF           // CLKO Enable
    #pragma config POSCMOD  = HS            // Primary Oscillator
    #pragma config IESO     = OFF           // Internal/External Switch-over
    #pragma config FSOSCEN  = OFF           // Secondary Oscillator Enable (KLO was off)
    #pragma config FNOSC    = PRIPLL        // Oscillator Selection
    #pragma config CP       = OFF           // Code Protect
    #pragma config BWP      = OFF           // Boot Flash Write Protect
    #pragma config PWP      = OFF           // Program Flash Write Protect
    #pragma config ICESEL   = ICS_PGx2      // ICE/ICD Comm Channel Select (ICE EMUC2/EMUD2 pins shared with PGC2/PGD2)
    #pragma config DEBUG    = ON            // Background Debugger Enable
#else
    #error "Please select correct part number"
#endif

// some defines about clocks
#define PERIPH_CLOCK	(SYST_CLOCK/(1 << OSCCONbits.PBDIV))

//-------User configurable macros begin---------
// ### unused for the moment
//#define MAJOR_VERSION 0
//#define MINOR_VERSION 5


// APP_FLASH_BASE_ADDRESS and APP_FLASH_END_ADDRESS reserves program Flash for the application
// Rule:
// 		1)The memory regions kseg0_program_mem, kseg0_boot_mem, exception_mem and
// 		kseg1_boot_mem of the application linker script must fall with in APP_FLASH_BASE_ADDRESS
// 		and APP_FLASH_END_ADDRESS
// 		2)The base address and end address must align on  4K address boundary

#define BOOTLOADER_SIZE             0x6000
#define APP_FLASH_BASE_ADDRESS      0x9D000000
#define PROGRAM_FLASH_END_ADRESS    (0x9D000000+BMXPFMSZ-1-BOOTLOADER_SIZE) // end of flash program memory - boot program place
#define APP_FLASH_END_ADDRESS       PROGRAM_FLASH_END_ADRESS

#define NVMOP_WORD_PGM    0x4001      // Word program operation
#define NVMOP_PAGE_ERASE  0x4004      // Page erase operation

const UINT countPerMicroSec = ((SYST_CLOCK/1000000)/2);

// Address of  the Flash from where the application starts executing
// Rule: Set APP_FLASH_BASE_ADDRESS to _RESET_ADDR value of application linker script
#if defined(__PIC32MX1XX_2XX__)
    // For PIC32MX1xx and PIC32MX2xx Controllers only
    #define FLASH_PAGE_SIZE		 		1024
    #define USER_APP_RESET_ADDRESS 	(0x9D006000 + 0x1000)
#elif defined(__PIC32MX3XX_7XX__)
    // For PIC32MX3xx to PIC32MX7xx Controllers only
    #define FLASH_PAGE_SIZE		 4096
    #define USER_APP_RESET_ADDRESS       (0x9D000000+BMXPFMSZ-BOOTLOADER_SIZE-0x10) //0x9D006000 // _RESET_ADDR place in boot ".ld"
#endif

#define BTLDR_ERROR     0x4E // 0x4E = "N"
#define BTLDR_OK        0x4B // 0x4B = "K"
#define BTLDR_ERASE     0x45 // 0x45 = "E"
#define BTLDR_ASKPIC    0xC1

/** V A R I A B L E S ********************************************************/
unsigned char USB_Buffer[64];
#define IS_WAITING      1
#define WAIT_START      1
#define WAIT_ERASE      3
#define ERASING_BOOT    4
#define ERASING_PROG    6
#define ERASING_DONE    8
#define WAIT_DATA       5
unsigned char Status = WAIT_START;
int waitingLoops = 0;

// for erasing
UINT8 nbPages;
UINT8 erasingPageNb = 0;
UINT32 jump[4];
UINT32 config[4];

// for write flash
int numData = 0;
BYTE dataBytes[256]; // arbitrary, must be a multiple of 4. 8 bits data long
UINT baseZoneMem[2] = {0x9D000000, 0xBFC00000};
BOOL writeOK = FALSE;


/** FUNCTIONS ***************************************************/

/////////////////////////////////////////////////////////////////////////
// Function: 	JumpToApp()
//
// Precondition:
//
// Input: 		None.
//
// Output:
//
// Side Effects:	No return from here.
//
// Overview: 	Jumps to application.
//
//
// Note:		 	None.
/////////////////////////////////////////////////////////////////////////
void JumpToApp(void)
{
    void (*fptr)(void);
    fptr = (void (*)(void))USER_APP_RESET_ADDRESS;
    fptr();
}

/********************************************************************
* Function: 	delay_us()
*
* Precondition:
*
* Input: 		Micro second
*
* Output:		None.
*
* Side Effects:	Uses Core timer. This may affect other functions using core timers.
				For example, core timer interrupt may not work, or may loose precision.
*
* Overview:     Provides Delay in microsecond.
*
*
* Note:		 	None.
********************************************************************/
void delay_us(UINT us)
{
    UINT targetCount;

    // Core timer increments every 2 sys clock cycles.
    // Calculate the counts required to complete "us".
    targetCount = countPerMicroSec * us;
    // Restart core timer.
    WriteCoreTimer(0);
    // Wait till core timer completes the count.
    while(ReadCoreTimer() < targetCount);
}

BOOL checkChkSum(BYTE chkSumReceived)
{
    // ### todo calculate checksum and compare to the one received
    return TRUE;
}

/********************************************************************
* Function: 	NVMemOperation()
*
* Precondition:
*
* Input: 		NV operation
*
* Output:		NV eror
*
* Side Effects:	This function must generate MIPS32 code only and
				hence the attribute (nomips16)
*
* Overview:     Performs reuested operation.
*
*
* Note:		 	None.
********************************************************************/
void NVMemOperation(UINT nvmop)
{
    // Enable Flash Write/Erase Operations
    NVMCON = NVMCON_WREN | nvmop;
    // Data sheet prescribes 6us delay for LVD to become stable.
    // To be on the safer side, we shall set 7us delay.
    delay_us(7);

    NVMKEY 	= 0xAA996655;
    NVMKEY 	= 0x556699AA;
    NVMCONSET 	= NVMCON_WR;

    // Wait for WR bit to clear
    while(NVMCON & NVMCON_WR);

    // Disable Flash Write/Erase operations
    NVMCONCLR = NVMCON_WREN;
}

/*********************************************************************
 * Function:        unsigned int NVMWriteWord(void* address, unsigned int data)
 *
 * Description:     The smallest block of data that can be programmed in
 *                  a single operation is 1 instruction word (4 Bytes).  The word at
 *                  the location pointed to by NVMADDR is programmed.
 *
 * PreCondition:    None
 *
 * Inputs:          address:   Destination address to write.
 *                  data:      Word to write.
 *
 * Output:          '0' if operation completed successfully.
 *
 * Side Effects:    This function must generate MIPS32 code only and
 *				hence the attribute (nomips16)
 *
 * Example:         NVMWriteWord((void*) 0xBD000000, 0x12345678)
 ********************************************************************/
void NVMemWriteWord(void* address, UINT data)
{
    NVMADDR = KVA_TO_PA((unsigned int)address);

    // Load data into NVMDATA register
    NVMDATA = data;

    // Unlock and Write Word
    NVMemOperation(NVMOP_WORD_PGM);
}

// Overview: erase boot OR prog memory
void eraseZoneFlash(void* startAddress, int numPages)
{
    NVMADDR = KVA_TO_PA((unsigned int) startAddress + (numPages*FLASH_PAGE_SIZE) );
    NVMemOperation(NVMOP_PAGE_ERASE);
}

/********************************************************************
 * Function:        void ProcessIO(void)
 *
 * PreCondition:    None
 *
 * Input:           None
 *
 * Output:          None
 *
 * Side Effects:    None
 *
 * Overview:        This function is a place holder for other user
 *                  routines. It is a mixture of both USB and
 *                  non-USB tasks.
 *
 * Note:            None
 *******************************************************************/
void ProcessIO(void)
{
    BYTE numBytesRead;
    int i;

    // User Application USB tasks
    if((USBDeviceState < CONFIGURED_STATE)||(USBSuspendControl==1)) return;

    if(mUSBUSARTIsTxTrfReady())
    {
        numBytesRead = getsUSBUSART(USB_Buffer,64);
        if(numBytesRead != 0) // if data are available
        {
            // check device from PC
            if (Status == WAIT_START)
            {
                if (USB_Buffer[0] == BTLDR_ASKPIC)  // enter bootloader mode
                {
                    USB_Buffer[0] = PIC_CODE; // send PIC ID to PC program
                    USB_Buffer[1] = BTLDR_OK; // and 'K' for "OK"
                    putUSBUSART(USB_Buffer, 2);
                    Status = WAIT_ERASE;
                    waitingLoops = 0;
               }
                return;
            }

            // prepare erasing
            if (Status == WAIT_ERASE)
            {
                if (USB_Buffer[0] == BTLDR_ERASE)  // erase prog mem
                {
                    // store jump to bootloader and config
                    for (i=0; i<4; i++)
                    {
                        jump[i] = *(UINT32*)(0xBFC00000+i*4);
                        config[i] = *(UINT32*)(0xBFC02FF0+i*4);
                    }

                    nbPages = (APP_FLASH_END_ADDRESS - APP_FLASH_BASE_ADDRESS + 1)/FLASH_PAGE_SIZE;
                    USB_Buffer[0] = nbPages+3;
                    putUSBUSART(USB_Buffer, 1); // send to PC nb pages to be erased (prog_size/FLASH_PAGE_SIZE + boot_size/FLASH_PAGE_SIZE)

                    Status = ERASING_BOOT;
                    return;
                }
            }

            // wait for 1s if there is data available
            // -> dataBytes[0] = nb real data (without header)
            //    dataBytes[1] = base zone mem code
            //    dataBytes[2] = address UpperSB
            //    dataBytes[3] = address MSB
            //    dataBytes[4] = address LSB
            if (Status == WAIT_DATA)
            {
                for (i=0; i < numBytesRead; i++)
                    dataBytes[numData] = USB_Buffer[i];
                if (numData == (dataBytes[0]+5)) // checksum (placed at nbData+4)
                {
                    if (checkChkSum(dataBytes[numData]))    // verify checksum and write data
                    {
                        for (i=0; i<dataBytes[0]; i+=4)
                            NVMemWriteWord((void*)(baseZoneMem[dataBytes[1]] + (dataBytes[2]<<16) + (dataBytes[3]<<8) + dataBytes[4] + i),
                                    dataBytes[i+5] + (dataBytes[i+6]<<8) + (dataBytes[i+7]<<16) + (dataBytes[i+8]<<24));

                        USB_Buffer[0] = BTLDR_OK;
                        putUSBUSART(USB_Buffer, 1);
                        writeOK = TRUE;
                    }
                    else // if checksum mismatch : send error code to PC
                    {
                        USB_Buffer[0] = BTLDR_ERROR;
                        putUSBUSART(USB_Buffer, 1);
                    }
                }

                if (writeOK) // prepare for a new packet
                {
                    writeOK = FALSE;
                    numData = 0;
                }
                else
                    numData++;

                waitingLoops = 0;
                return;
            }
        }

        // erase boot flash memory
        if (Status == ERASING_BOOT)
        {
            eraseZoneFlash((void*)0xBFC00000, erasingPageNb);
            USB_Buffer[0] = BTLDR_ERASE;
            putUSBUSART(USB_Buffer, 1);// page erased OK
            erasingPageNb++;
            if (erasingPageNb == 3)
            {
                Status = ERASING_PROG;
                erasingPageNb = 0;
            }
            return;
        }

        // erase program flash memory
        if (Status == ERASING_PROG)
        {
            eraseZoneFlash((void*)APP_FLASH_BASE_ADDRESS, erasingPageNb);
            USB_Buffer[0] = BTLDR_ERASE;
            putUSBUSART(USB_Buffer, 1);// page erased OK
            erasingPageNb++;

            if (erasingPageNb == nbPages)
            {
                Status = ERASING_DONE;
            }

            return;
        }

        // erasing done
        if (Status == ERASING_DONE)
        {
            // replace jump and config
            for( i = 0; i < 4; i++ )
            {
                NVMemWriteWord((void*)(0xBFC00000+i*4), jump[i]);
                NVMemWriteWord((void*)(0xBFC02FF0+i*4), config[i]);
            }

            USB_Buffer[0] = BTLDR_OK;
            putUSBUSART(USB_Buffer, 1);// page erased OK

            Status = WAIT_DATA;
            waitingLoops = 0;

            return;
        }
    }
}		//end ProcessIO

/******************************************************************************
 * Function:        void main(void)
 *
 * PreCondition:    None
 *
 * Input:           None
 *
 * Output:          None
 *
 * Side Effects:    None
 *
 * Overview:        Main program entry point.
 *
 * Note:            None
 *****************************************************************************/
int main(void)
{
    InitializeSystem();

    while(1)
    {
        USBDeviceTasks(); 
        // Application-specific tasks.
        ProcessIO();
        CDCTxService();

        // wait for 1sec if a data is received, if not then exit the bootloader and launch the application
        waitingLoops++;
        if ((Status & IS_WAITING)&&(waitingLoops > (SYST_CLOCK/675)))
        {
            U1CON = 0; // disable USB
            JumpToApp();
        }
    }//end while
}//end main



/** EOF main.c *************************************************/

