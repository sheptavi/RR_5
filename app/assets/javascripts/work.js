var currentThemeName = '';
var currentThemeId = null;
var currentImageId = null;
var currentIndex = 0;
var totalImages = 0;

// Кнопка выбора темы
$(document).on('click', '#select_theme_btn', function() {
  $.get('/choose_theme', function(data) {
    var select = $('#theme_dropdown');
    select.empty();
    select.append('<option value="">--- Выберите тему ---</option>');
    
    $.each(data.themes, function(index, theme) {
      select.append('<option value="' + theme + '">' + theme + '</option>');
    });
    
    $('.theme_select_container').show();
    $('#select_theme_btn').hide();
  });
});

// Выбор темы из списка
$(document).on('change', '#theme_dropdown', function() {
  var themeName = $(this).val();
  if (!themeName) return;
  
  currentThemeName = themeName;
  
  $.post('/display_theme', { theme: themeName }, function(data) {
    if (data.error) {
      alert(data.error);
      return;
    }
    
    currentThemeId = data.theme_id;
    $('.up-theme h2').text(data.theme_name);
    $('.up').text(data.image_name);
    $('#main_image').attr('src', data.image_url);
    currentImageId = data.image_id;
    currentIndex = data.current_index;
    totalImages = data.total_images;
    $('#user_value').text('Ваша оценка: ' + (data.user_value > 0 ? data.user_value : 'не оценено'));
    $('#common_value').text('Средняя оценка экспертов: ' + (data.common_value > 0 ? data.common_value : 'нет оценок'));
    $('.img-left-side, .img-right-side').show();
    $('.theme_select_container').hide();
    $('#select_theme_btn').show();
    $('#theme_dropdown').val('');
  });
});

// Оценка
$(document).on('click', '.btn-rating', function() {
  var value = $(this).data('value');
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

// Следующее изображение
$(document).on('click', '.img-right-side', function() {
  if (!currentThemeName) {
    alert('Сначала выберите тему');
    return;
  }
  
  $.ajax({
    type: "POST",
    url: "/api/next_image",
    data: { index: currentIndex, theme_id: currentThemeId, length: totalImages },
    dataType: 'json'
  }).done(function(data) {
    currentIndex = data.new_image_index;
    currentImageId = data.image_id;
    $('.up').text(data.name);
    $('#main_image').attr('src', data.file);
    $('#user_value').text('Ваша оценка: ' + (data.user_valued ? data.value : 'не оценено'));
    $('#common_value').text('Средняя оценка экспертов: ' + (data.common_ave_value > 0 ? data.common_ave_value : 'нет оценок'));
  });
});

// Предыдущее изображение
$(document).on('click', '.img-left-side', function() {
  if (!currentThemeName) {
    alert('Сначала выберите тему');
    return;
  }
  
  $.ajax({
    type: "POST",
    url: "/api/prev_image",
    data: { index: currentIndex, theme_id: currentThemeId, length: totalImages },
    dataType: 'json'
  }).done(function(data) {
    currentIndex = data.new_image_index;
    currentImageId = data.image_id;
    $('.up').text(data.name);
    $('#main_image').attr('src', data.file);
    $('#user_value').text('Ваша оценка: ' + (data.user_valued ? data.value : 'не оценено'));
    $('#common_value').text('Средняя оценка экспертов: ' + (data.common_ave_value > 0 ? data.common_ave_value : 'нет оценок'));
  });
});

// Инициализация
$(document).ready(function() {
  $('.img-left-side, .img-right-side').hide();
  $('.theme_select_container').hide();
});
