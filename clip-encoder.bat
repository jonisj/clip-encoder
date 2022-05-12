@echo off
SETLOCAL

IF EXIST %~1 (

    WHERE /q ffmpeg
    IF ERRORLEVEL 1 (
        ECHO Install FFmpeg...
        PAUSE
        EXIT /B
    )

    SET /p clip_name="Clip name: "
    SET /p start_at="Start at (HH:MM:SS): "
    SET /p end_at="End at (HH:MM:SS): "
    SET /P quality="Quality CRF (20): " || SET quality=20

    CALL :format_output_name output "%~1" "%clip_name%"

    ffmpeg ^
        -ss "%start_at%" ^
        -to "%end_at%" ^
        -i "%~1" ^
        -vcodec libx265 ^
        -crf "%quality%" ^
        "%output%"
)

PAUSE
EXIT /B %ERRORLEVEL%

:: Output name & path for the encoded file
:format_output_name
    FOR %%i in ("%~2") do SET return=Encoded\%%~ni-encoded%%~xi
    CALL SET "return=%%return:Replay=%~3 -%%%"

    SET "%~1=%return%"
EXIT /B 0
