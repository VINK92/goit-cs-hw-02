#!/bin/bash

# Список вебсайтів для перевірки
websites=("https://google.com" "https://facebook.com" "https://twitter.com")

# Назва файлу логів
log_file="website_status.log"

# Видаляємо старий файл логів, якщо він існує
if [ -f $log_file ]; then
  rm $log_file
fi

# Перевірка доступності вебсайтів
for website in "${websites[@]}"
do
  # Використовуємо curl для перевірки доступності, ігноруючи перенаправлення
  response=$(curl -L -o /dev/null -s -w "%{http_code}\n" $website)
  status=$?

  # Перевіряємо статус код
  if [ $status -ne 0 ]; then
    echo "$website is DOWN (curl failed with status $status)" | tee -a $log_file
  elif [ $response -eq 200 ]; then
    echo "$website is UP" | tee -a $log_file
  else
    echo "$website is DOWN (HTTP status $response)" | tee -a $log_file
  fi
done

# Виведення повідомлення про завершення
echo "Результати записано у файл $log_file"
