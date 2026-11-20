#!/bin/bash
# server-info.sh: "паспорт" сервера. Выводит на экран и сохраняет в файл.

OUT="$HOME/server-info.txt"

section() {
    echo
    echo "=== $1 ==="
}

report() {
    echo "Отчёт создан: $(date '+%Y-%m-%d %H:%M:%S')"

    section "Система"
    echo "Имя сервера: $(hostname)"
    grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"'
    echo "Ядро: $(uname -r)"
    echo "Архитектура: $(uname -m)"

    section "Время работы и нагрузка"
    uptime
    echo "Ядер процессора: $(nproc)"

    section "Память"
    free -h

    section "Диск (корень /)"
    df -h /

    section "Сеть (адреса)"
    ip -br a

    section "Открытые порты (слушают)"
    ss -tln

    section "Запущенные службы"
    systemctl list-units --type=service --state=running --no-pager --no-legend | awk '{print $1}'

    section "Топ-5 процессов по памяти"
    ps -eo pid,user,%mem,%cpu,comm --sort=-%mem | head -6
}

report | tee "$OUT"
echo
echo "Сохранено в: $OUT"
