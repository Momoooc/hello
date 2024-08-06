@echo off
cls
color 0C
echo 提示：请使用管理员模式运行！
echo.
echo 提示：请使用管理员模式运行！
echo.
echo 提示：请使用管理员模式运行！
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
echo 立即使用本脚本让WIN10自动输入开机密码登录？
echo.
echo 否：关闭本窗口。
echo.
echo 是：任意键继续。

pause > nul
cls
echo.
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\PasswordLess\Device" /v "DevicePasswordLessBuildVersion" /t REG_DWORD /d 0x00000000 /f
pause > nul
start Netplwiz
cls
echo.
color 0A
echo 请依照下列步骤完成设置.

echo.
color 0A
echo     1.请在弹出的输入框取消勾选 "要使用本计算机，用户必须输入用户名和密码".

echo.
color 0A
echo     2.点击【应用】按钮.

echo.
color 0A
echo     3.在弹出的窗口两次输入密码.

echo.
color 0A
echo     4.点击确定.

echo.
color 0A
echo 设置完成，按任意键关闭程序.

pause > nul
