var currentThemeName = '';
var currentThemeId = null;
var currentImageId = null;
var currentIndex = 0;
var selectedRating = null;
var totalImages = 0;

// Получаем текущую локаль из HTML
var currentLocale = document.documentElement.lang || 'ru';

// Функция для перевода текстов
function t(key) {
  var translations = {
    ru: {
      select_theme: "--- Выберите тему ---",
      your_rating: "Ваша оценка:",
      not_rated: "не оценено",
      no_ratings: "нет оценок",
      avg_rating: "Средняя оценка экспертов:",
      saving: "Сохранение...",
      choose_theme_first: "Сначала выберите тему",
      choose_rating_first: "Сначала выберите оценку (1-10)",
      save_error: "Ошибка сохранения оценки",
      save_fail: "Не удалось сохранить оценку",
      selected_rating: "Выбрана оценка:",
      save_hint: "(нажмите \"Сохранить\")"
    },
    en: {
      select_theme: "--- Select theme ---",
      your_rating: "Your rating:",
      not_rated: "not rated",
      no_ratings: "no ratings",
      avg_rating: "Average expert rating:",
      saving: "Saving...",
      choose_theme_first: "Please select a theme first",
      choose_rating_first: "Please select a rating (1-10) first",
      save_error: "Error saving rating",
      save_fail: "Failed to save rating",
      selected_rating: "Selected rating:",
      save_hint: "(click \"Save\")"
    }
  };
  return translations[currentLocale][key] || translations['ru'][key];
}

console.log('Work.js загружен, локаль:', currentLocale);

// Кнопка выбора темы
$(document).on('click', '#select_theme_btn', function() {
  $.get('/choose_theme', function(data) {
    var select = $('#theme_dropdown');
    select.empty();
    select.append('<option value="">' + t('select_theme') + '</option>');
    
    $.each(data.themes, function(index, theme) {
      select.append('<option value="' + theme.name + '">' + theme.name + '</option>');
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
    $('#user_value').text(t('your_rating') + ' ' + (data.user_value > 0 ? data.user_value : t('not_rated')));
    $('#common_value').text(t('avg_rating') + ' ' + (data.common_value > 0 ? data.common_value : t('no_ratings')));
    $('.img-left-side, .img-right-side').show();
    $('.theme_select_container').hide();
    $('#select_theme_btn').show();
    $('#theme_dropdown').val('');
  });
});

// Выбор оценки (без сохранения)
$(document).on('click', '.btn-rating', function() {
  selectedRating = $(this).data('value');
  console.log('Выбрана оценка:', selectedRating);
  
  $('.btn-rating').css('background', 'linear-gradient(135deg, #8b5cf6 0%, #6d28d9 100%)');
  $(this).css('background', 'linear-gradient(135deg, #10b981 0%, #059669 100%)');
  
  $('#user_value').text(t('selected_rating') + ' ' + selectedRating + ' ' + t('save_hint'));
});

// Сохранение оценки
$(document).on('click', '#save_rating', function() {
  console.log('Кнопка "Сохранить оценку" нажата');
  
  if (!currentImageId) {
    alert(t('choose_theme_first'));
    return;
  }
  
  if (!selectedRating) {
    alert(t('choose_rating_first'));
    return;
  }
  
  console.log('Сохраняем оценку:', selectedRating, 'для изображения:', currentImageId);
  
  $('#user_value').text(t('saving'));
  
  $.post('/rate_image', {
    image_id: currentImageId,
    value: selectedRating
  }, function(data) {
    console.log('Ответ сервера:', data);
    if (data.success) {
      $('#user_value').text(t('your_rating') + ' ' + selectedRating);
      $('#common_value').text(t('avg_rating') + ' ' + data.common_value);
      
      $('.btn-rating').css('background', 'linear-gradient(135deg, #8b5cf6 0%, #6d28d9 100%)');
      selectedRating = null;
    } else {
      alert(t('save_error'));
    }
  }).fail(function() {
    alert(t('save_fail'));
  });
});

// Следующее изображение
$(document).on('click', '.img-right-side', function() {
  if (!currentThemeName) {
    alert(t('choose_theme_first'));
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
    $('#user_value').text(t('your_rating') + ' ' + (data.user_valued ? data.value : t('not_rated')));
    $('#common_value').text(t('avg_rating') + ' ' + (data.common_ave_value > 0 ? data.common_ave_value : t('no_ratings')));
  });
});

// Предыдущее изображение
$(document).on('click', '.img-left-side', function() {
  if (!currentThemeName) {
    alert(t('choose_theme_first'));
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
    $('#user_value').text(t('your_rating') + ' ' + (data.user_valued ? data.value : t('not_rated')));
    $('#common_value').text(t('avg_rating') + ' ' + (data.common_ave_value > 0 ? data.common_ave_value : t('no_ratings')));
  });
});

// Инициализация
$(document).ready(function() {
  console.log('DOM готов');
  $('.img-left-side, .img-right-side').hide();
  $('.theme_select_container').hide();
});
