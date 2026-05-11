# Очистка старых данных
puts "Очистка базы данных"
Value.destroy_all
Image.destroy_all
Theme.destroy_all
User.destroy_all

# Сброс счетчиков id
ActiveRecord::Base.connection.reset_pk_sequence!('themes')
ActiveRecord::Base.connection.reset_pk_sequence!('images')
ActiveRecord::Base.connection.reset_pk_sequence!('users')
ActiveRecord::Base.connection.reset_pk_sequence!('values')

# 1. Создание тем
puts "\n1. Создание тем"

themes = [
  { name: "--- Нет темы ---", qty_items: 0 },
  { name: "Пейзажи и природа", qty_items: 4 },
  { name: "Городская архитектура", qty_items: 4 },
  { name: "Животные и дикая природа", qty_items: 4 },
  { name: "Портреты и люди", qty_items: 4 }
]

themes.each do |theme|
  t = Theme.create!(theme)
  puts "  Создана тема: #{t.name}"
end

# 2. Создание изображений
puts "\n2. Создание изображений"

images_data = [
  # Тема 2: Пейзажи (theme_id: 2)
  { name: "Горный пейзаж", file: "image_1.jpg", ave_value: nil, theme_id: 2 },
  { name: "Океанский закат", file: "image_2.jpg", ave_value: nil, theme_id: 2 },
  { name: "Лесное озеро", file: "image_3.jpg", ave_value: nil, theme_id: 2 },
  { name: "Зимний лес", file: "image_4.jpg", ave_value: nil, theme_id: 2 },
  
  # Тема 3: Города (theme_id: 3)
  { name: "Ночной мегаполис", file: "image_5.jpg", ave_value: nil, theme_id: 3 },
  { name: "Старый город", file: "image_6.jpg", ave_value: nil, theme_id: 3 },
  { name: "Современная архитектура", file: "image_7.jpg", ave_value: nil, theme_id: 3 },
  { name: "Улицы Парижа", file: "image_8.jpg", ave_value: nil, theme_id: 3 },
  
  # Тема 4: Животные (theme_id: 4)
  { name: "Лиса в лесу", file: "image_9.jpg", ave_value: nil, theme_id: 4 },
  { name: "Сова", file: "image_10.jpg", ave_value: nil, theme_id: 4 },
  { name: "Олень", file: "image_1.jpg", ave_value: nil, theme_id: 4 },
  { name: "Бабочка на цветке", file: "image_2.jpg", ave_value: nil, theme_id: 4 },
  
  # Тема 5: Портреты (theme_id: 5)
  { name: "Девушка с книгой", file: "image_3.jpg", ave_value: nil, theme_id: 5 },
  { name: "Старик у моря", file: "image_4.jpg", ave_value: nil, theme_id: 5 },
  { name: "Ребенок улыбается", file: "image_5.jpg", ave_value: nil, theme_id: 5 },
  { name: "Художник за работой", file: "image_6.jpg", ave_value: nil, theme_id: 5 }
]

images_data.each do |img|
  i = Image.create!(img)
  puts "  Добавлено изображение: #{i.name}"
end

# 3. Создание пользователей
puts "Создание пользователей"

if User.count == 0
  User.create!(
    email: "expert@example.com",
    name: "Эксперт Иванов",
    password_digest: "temp"
  )
  User.create!(
    email: "user2@example.com",
    name: "Петр Сидоров",
    password_digest: "temp"
  )
  User.create!(
    email: "user3@example.com",
    name: "Анна Смирнова",
    password_digest: "temp"
  )
  puts "  Создано пользователей: #{User.count}"
else
  puts "  Пользователи уже есть: #{User.count}"
end

# 4. Создание оценок
puts
s "\n4. Создание оценок"

if Value.count == 0 && User.count > 0 && Image.count > 0
  User.all.each do |user|
    Image.all.each do |image|
      Value.create!(
        user: user,
        image: image,
        value: rand(1..100)
      )
    end
    puts "  Пользователь #{user.name}: создано #{Image.count} оценок"
  end
  puts "  Всего оценок: #{Value.count}"
else
  puts "  Оценки уже есть или нет пользователей/изображений"
end

# 5. Расчет средних оценок
puts "\n5. Расчет средних оценок для изображений"

Image.all.each do |image|
  avg = image.values.average(:value)
  if avg
    image.update(ave_value: avg.round(2))
    puts "  #{image.name}: средняя оценка = #{avg.round(2)}"
  else
    puts "  #{image.name}: нет оценок"
  end
end

# Итоги
puts "\n" + "=" * 50
puts "Загружено в базу данных:"
puts "- Тем: #{Theme.count}"
puts "- Изображений: #{Image.count}"
puts "- Пользователей: #{User.count}"
puts "- Оценок: #{Value.count}"
puts "=" * 50
