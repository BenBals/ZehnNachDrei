# taking the raw data and inserting the needed brs and stuff
Template.Article.helpers {
  processToHtml: (raw) ->
    root.processToHtml raw
  timestampToGermanDate: utils.timestampToGermanDate
}

Template.ArticleCard.helpers processToHtml: (raw) ->
  root.processToHtml raw

Template.Article.events {
  'click .backButton': ->
    # go to the last page
    history.back()
}

Template.Article.onCreated ->
  # scroll to the top on the new article
  $(document).scrollTop(0)

Template.Article.onRendered ->
  data = this.data
  if data.pollData
    root.utils.renderPoll(data.pollData) 