jQuery ->
  pad = (n) -> if n < 10 then "0#{n}" else String(n)
  $(".filter-time-zone").bind 'click', ->
    gap = (new Date()).getTimezoneOffset() * -1
    hour = parseInt(gap/60)
    zone_str = "GMT#{if gap < 0 then '-' else '+'}#{pad(parseInt(gap/60))}:#{pad(gap % 60)}"
    $("##{$(this).attr('data-target')}").find('option').each ->
        if $(this).text().indexOf(zone_str) < 0
          $(this).remove()
