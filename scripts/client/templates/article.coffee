Template.Article.helpers {
  # alias to the root function processToHtml (taking the raw data and inserting the needed brs and stuff)
  processToHtml: (raw) ->
    root.processToHtml raw
  # alias to the util, which formats a date in the german format (DD.MM.YYYY)
  timestampToGermanDate: utils.timestampToGermanDate
  # this is JSON.parse for the template
  parse: JSON.parse
}

Template.ArticleCard.helpers {
  # alias to the root function processToHtml (taking the raw data and inserting the needed brs and stuff)
  processToHtml: (raw) ->
    root.processToHtml raw
}

Template.Article.events {
  'click .backButton': ->
    # go to the last page
    history.back()
}

Template.Article.onCreated ->
  # scroll to the top on the new article
  $(document).scrollTop(0)