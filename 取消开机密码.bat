@echo off
cls
color 0C
echo ��ʾ����ʹ�ù���Աģʽ���У�
echo.
echo ��ʾ����ʹ�ù���Աģʽ���У�
echo.
echo ��ʾ����ʹ�ù���Աģʽ���У�
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo ����ʹ�ñ��ű���WIN10�Զ����뿪�������¼��
echo.
echo �񣺹رձ����ڡ�
echo.
echo �ǣ������������

pause > nul
cls
echo.
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\PasswordLess\Device" /v "DevicePasswordLessBuildVersion" /t REG_DWORD /d 0x00000000 /f
pause > nul
start Netplwiz
cls
echo.
color 0A
echo ���������в����������.

echo.
color 0A
echo     1.���ڵ����������ȡ����ѡ "Ҫʹ�ñ���������û����������û���������".

echo.
color 0A
echo     2.�����Ӧ�á���ť.

echo.
color 0A
echo     3.�ڵ����Ĵ���������������.

echo.
color 0A
echo     4.���ȷ��.

echo.
color 0A
echo ������ɣ���������رճ���.

pause > nul
