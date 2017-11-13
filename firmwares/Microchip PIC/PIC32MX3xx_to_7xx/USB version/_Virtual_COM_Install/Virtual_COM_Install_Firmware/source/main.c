/* ---------------------------------------------------------------------------------------
 * PIC32 firmware for virtual COM installation
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
 * ---------------------------------------------------------------------------------------
 */

// legend:
//  o to do
//  ~ to test
//  x working
//
// v0.1 (02.2014):
//  x initial release
//    debug part of the boot flash (debug_exec_mem) as I wanted to do.

#include <p32xxxx.h>
#include <plib.h>
#include "main.h"

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

/** V A R I A B L E S ********************************************************/
unsigned char USB_Buffer[64];

/** F U N C T I O N S ***************************************************/


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
    }//end while
}//end main



/** EOF main.c *************************************************/

