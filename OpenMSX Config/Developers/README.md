# OpenMSX Config
OpenMSX Configuration files for developers

- Copy **NABU-PC** folder to /Share/Machines
- Copy **NaBu8CUSTOM.ROM** to /Share/systemroms
  
Start the emulator and  load the ROM in to RAM in the console ([F10] Key)<br>
**load_debuggable memory NaBu8CUSTOM.ROM 0x0000)**<br>
The NaBu will start automaticly now and keeps looping at adress #140d (Loading NOW is shown)<br><br>

Now load the 000001.nabu in RAM and it wil start the programm automaticly.<br>
**load_debuggable memory .000001.nabu 0x140d**<br>