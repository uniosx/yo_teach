class LessonPlan

  this.init = ->
    initEditor()
    $('#dropdown').change filter
    setTab()
    standardsSearchInit()
    $('.calendar-week').scrollTop 0
    week = $('#hour-6')
    if week.length > 0
      $('.calendar-week').scrollTop week.offset().top

  initEditor = ->
    if $('#lesson_plan_body').length > 0
      if CKEDITOR.instances.lesson_plan_body
        $('.cke_textarea_inline').remove()
        delete CKEDITOR.instances.lesson_plan_body
      CKEDITOR.inline 'lesson_plan_body'

  filter = ->
    course = $(this).find('select :selected')
    if course.text() == 'All Courses'
      Turbolinks.visit '/lesson_plans'
    else
      Turbolinks.visit '/lesson_plans?course=' + course.val()

  setTab = ->
    if /lesson_plans/.test(document.URL)
      tab = document.URL.split('#')[1]
      link = $('a[href="#' + tab + '"') if tab
      if tab != 'undefined' && link && link.length != 0
        link.tab('show')
      $('a[data-toggle="tab"]').click ->
        tab = this.name
        new_url = document.URL.replace /[?#].+/, "##{tab}"
        window.history.pushState({path: new_url}, 'YoTeach', new_url)

  standardsSearchInit = ->
    $('#standards-search').click (e) ->
      e.preventDefault()
      url = document.URL
      url = url.replace /[?&]search\=.+[&#]/, (match) ->
        if /#$/.test match then '#' else '&'
      search = $('#search').val()
      url_pieces = url.split('#')

      search_string = if /\?+/.test(url_pieces) then '&' else '?'
      search_string += "search=#{encodeURIComponent(search)}"

      new_url = if url_pieces[1]
        "#{url_pieces[0]}#{search_string}##{url_pieces[1]}"
      else
        "#{url}#{search_string}#standards-tab"

      Turbolinks.visit new_url

$(document).ready LessonPlan.init
$(document).on 'page:load', LessonPlan.init
