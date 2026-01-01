# GTAClient - Troubleshooting Guide

## Problem: VirtBot.exe closes immediately

Если VirtBot.exe запускается и сразу закрывается, попробуй следующее:

### Option 1: Force Console Open
```bash
run_with_console.bat
```
Этот батник форсирует консоль оставаться открытой.

### Option 2: Test from Source (требует Python)
```bash
test_source.bat
```
Запускает бот из исходников (без компиляции) - покажет ошибку сразу.

### Option 3: Check Logs
Даже если exe закрывается, логи могут быть созданы:
```
cd GTAClient
dir logs
type logs\<latest-date>.log
```

### Option 4: Manual Console Launch
```cmd
# Открой cmd.exe
cd GTAClient
VirtBot.exe
```

## Возможные причины

1. **Отсутствуют зависимости Windows** (pywin32, etc)
2. **Нет интернета** - бот не может подключиться к API
3. **Блокировка антивирусом**
4. **Отсутствует .env файл** (опционально, но может быть)

## Что делать если всё равно не работает

1. Запусти `test_source.bat` (если есть Python) - увидишь точную ошибку
2. Проверь `logs/` директорию
3. Отключи антивирус временно
4. Скинь скриншот что видишь при запуске через `run_with_console.bat`
