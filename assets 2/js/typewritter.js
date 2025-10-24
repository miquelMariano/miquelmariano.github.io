window.onload = function () {
  gAnalyticsPageView();
  init();
}


function init() {
  TypeWritter.start({
    containerId: 'typePad',
    extractClass: 'sentence',
    cursorClass: 'cursor'
  });
}

function gAnalyticsPageView() {
  ga('send', 'pageview');
}

function gAnalyticsLink(action, label) {
  ga('send', 'event', 'link', action, label);
}
