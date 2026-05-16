var currentThemeName = '';
var currentImageId = null;
var currentIndex = 0;
var totalImages = 0;

console.log('Work.js загружен (версия 3.0)');

// 1. ВЫБОР ТЕМЫ (показываем выпадающий список)
$(document).on('click', '#select_theme_btn', function() {
  console.log('Кнопка "Выбрать тему" нажата');
  
  $.get('/choose_theme', function(data) {
    console.log('Получен список тем:', data);
    
    var select = $('#theme_dropdown');
    select.empty();
    select.append('<option value="">--- Выберите тему ---</option>');
    
    $.each(data.themes, function(index, theme) {
      select.append('<option value="' + theme[0] + '">' + theme[0] + '</option>');
    });
    
    $('.theme_select_container').show();
    $('#select_theme_btn').hide();
  });
});

// 2. ВЫБОР ТЕМЫ ИЗ СПИСКА → ЗАГРУЖАЕМ КАРТИНКУ
$(document).on('change', '#theme_dropdown', function() {
  var themeName = $(this).val();
  console.log('Выбрана тема:', themeName);
  
  if (!themeName) return;
  
  currentThemeName = themeName;
  
  // Показываем загрузку
  $('#main_image').attr('src', 'https://via.placeholder.com/500x400?text=Loading...');
  $('.up').text('Загрузка...');
  
  $.post('/display_theme', { theme: themeName }, function(data) {
    console.log('Получены данные:', data);
    
    if (data.error) {
      alert(data.error);
      return;
    }
    
    // Обновляем заголовок темы
    $('.up-theme h2').text(data.theme_name);
    
    // Обновляем название изображения
    $('.up').text(data.image_name);
    
    // ОБНОВЛЯЕМ КАРТИНКУ
    var imageUrl = data.image_url;
    console.log('Устанавливаем src:', imageUrl);
    
    // Способ 1
    $('#main_image').attr('src', imageUrl);
    
    // Способ 2
    var img = document.getElementById('main_image');
    if (img) {
      img.src = imageUrl;
      console.log('DOM обновлён, новый src:', img.src);
    }
    
    // Сохраняем данные
    currentImageId = data.image_id;
    currentIndex = data.current_index;
    totalImages = data.total_images;
    
    // Обновляем оценки
    $('#user_value').text('Ваша оценка: ' + (data.user_value > 0 ? data.user_value : 'не оценено'));
    $('#common_value').text('Средняя оценка экспертов: ' + (data.common_value > 0 ? data.common_value : 'нет оценок'));
    
    // Показываем кнопки
    $('.img-left-side, .img-right-side').show();
    $('.theme_select_container').hide();
    $('#select_theme_btn').show();
    $('#theme_dropdown').val('');
    
  }).fail(function() {
    alert('Не удалось загрузить изображения');
    $('.up').text('Ошибка загрузки');
  });
});

// 3. ОЦЕНКА (кнопки 1-10) 
$(document).on('click', '.btn-rating', function() {
  var value = $(this).data('value');
  console.log('Оценка нажата:', value);
  
  if (!currentImageId) {
    alert('Сначала выберите тему');
    return;
  }
  
  $('#user_value').text('Ваша оценка: ' + value);
  
  $.post('/rate_image', { 
    image_id: currentImageId, 
    value: value 
  }, function(data) {
    if (data.success) {
      $('#common_value').text('Средняя оценка экспертов: ' + data.common_value);
    }
  });
});

// 4. СЛЕДУЮЩЕЕ ИЗОБРАЖЕНИЕ
$(document).on('click', '.img-right-side', function() {
  console.log('Следующее');
  
  if (!currentThemeName) {
    alert('Сначала выберите тему');
    return;
  }
  
  $.post('/next_image', { 
    theme_name: currentThemeName, 
    current_index: currentIndex 
  }, function(data) {
    if (data.error) {
      alert(data.error);
      return;
    }
    
    $('#main_image').attr('src', data.image_url);
    $('.up').text(data.image_name);
    currentImageId = data.image_id;
    currentIndex = data.current_index;
    $('#user_value').text('Ваша оценка: ' + (data.user_value > 0 ? data.user_value : 'не оценено'));
    $('#common_value').text('Средняя оценка экспертов: ' + (data.common_value > 0 ? data.common_value : 'нет оценок'));
  });
});

// 5. ПРЕДЫДУЩЕЕ ИЗОБРАЖЕНИЕ
$(document).on('click', '.img-left-side', function() {
  console.log('Предыдущее');
  
  if (!currentThemeName) {
    alert('Сначала выберите тему');
    return;
  }
  
  $.post('/prev_image', { 
    theme_name: currentThemeName, 
    current_index: currentIndex 
  }, function(data) {
    if (data.error) {
      alert(data.error);
      return;
    }
    
    $('#main_image').attr('src', data.image_url);
    $('.up').text(data.image_name);
    currentImageId = data.image_id;
    currentIndex = data.current_index;
    $('#user_value').text('Ваша оценка: ' + (data.user_value > 0 ? data.user_value : 'не оценено'));
    $('#common_value').text('Средняя оценка экспертов: ' + (data.common_value > 0 ? data.common_value : 'нет оценок'));
  });
});

// 6. ИНИЦИАЛИЗАЦИЯ
$(document).ready(function() {
  console.log('DOM готов');
  $('.img-left-side, .img-right-side').hide();
  $('.theme_select_container').hide();
});

