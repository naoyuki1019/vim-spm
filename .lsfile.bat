rem dir & findstr
dir /s /b /a-d * | findstr /i /v "\\\.git\\" > .lsfile-win

