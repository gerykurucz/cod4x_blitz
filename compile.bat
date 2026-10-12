del mod.ff

xcopy images ..\..\raw\images /SY
xcopy mp ..\..\raw\mp /SY
xcopy shock ..\..\raw\shock /SY
xcopy ui_mp ..\..\raw\ui_mp /SY
xcopy weapons ..\..\raw\weapons /SY
xcopy xmodel ..\..\raw\xmodel /SY
xcopy localizedstrings ..\..\raw\localizedstrings /SY

xcopy fx ..\..\raw\fx /SY
xcopy material_properties ..\..\raw\material_properties\ /SY
xcopy materials ..\..\raw\materials\ /SY
xcopy sound ..\..\raw\sound\ /SY
xcopy soundaliases ..\..\raw\soundaliases\ /SY

copy /Y mod.csv ..\..\zone_source

cd ..\..\bin

linker_pc.exe -language english -compress -cleanup mod

cd ..\mods\blitz2

copy ..\..\zone\english\mod.ff

7za a -r -tzip mod.iwd sound
7za a -r -tzip mod.iwd soundalliases
7za a -r -tzip mod.iwd images
pause
close