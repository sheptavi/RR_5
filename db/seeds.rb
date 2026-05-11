# Очистка старых данных (чтобы не было дублей)
puts "Очистка базы данных..."
Assessment.destroy_all
Image.destroy_all

# Создание тестовых изображений
puts "Создание изображений..."

images = [
  {
    title: "Горы Альпы",
    description: "Красивый горный пейзаж со снежными вершинами",
    image_url: "https://picsum.photos/id/104/500/400"
  },
  {
    title: "Океанский закат",
    description: "Закат над Тихим океаном, спокойствие и красота",
    image_url: "https://picsum.photos/id/15/500/400"
  },
  {
    title: "Ночной мегаполис",
    description: "Городские огни и ночная жизнь",
    image_url: "https://picsum.photos/id/1/500/400"
  },
  {
    title: "Утренний лес",
    description: "Туман над лесом, первые лучи солнца",
    image_url: "https://picsum.photos/id/96/500/400"
  },
  {
    title: "Дикая природа",
    description: "Лиса в естественной среде обитания",
    image_url: "https://picsum.photos/id/145/500/400"
  },
  {
    title: "Архитектура",
    description: "Современное здание и небо",
    image_url: "https://picsum.photos/id/20/500/400"
  }
]

images.each do |img|
  Image.create!(img)
  puts "  Добавлено: #{img[:title]}"
end

puts "=" * 50
puts "Готово! Создано #{Image.count} изображений."
puts "=" * 50

# Показ всех созданных изображений
Image.all.each do |image|
  puts "#{image.id}. #{image.title} - #{image.image_url}"
end
