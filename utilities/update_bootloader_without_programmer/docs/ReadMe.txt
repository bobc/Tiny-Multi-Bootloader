Hi All,

I will introduce a self-writing program in the bootloader ("Image2.jpg"):
Use of self-writing is limited, shade for evaluation purposes is strong.
That the bootloader of the current is not corrupted is limited conditions.
You need to create for each device.
You need terminal software.
I will show below some use:
  1.Temporarily change the operation of the register, such as ports and.
  2.Temporarily change the serial TXn, the RXn.
  3.Changing the communication means such as RS232C-> RS458.

How to use it:
  1.Write this program in Tiny PIC/AVR Bootloader+.
  2.Turn off the power of the board
  3.Start the Teraterm ("1_This screen will be displayed first.jpg").
    Please do the following set of TeraTerm to write without problem ("Image1.jpg"):
      menu->Setup->serial Port...
        Transmit delay = 100 ms/line
  4.Turn on the power of the board.
  5.The drag-and-drop to TeraTerm the HEX file that you want to rewrite.
  6.Complete rewrite, "Rewrite Done" message is displayed ("2_Rewrite the boot loader if you drag and drop the Hex file.jpg").

Best regards,
Dan

------------------------------------------------------------------------

