document.addEventListener('DOMContentLoaded', function(){
  const replyBtn = document.getElementsByClassName('reply-btn');
  const replyPostBtn = document.getElementsByClassName('reply-post-btn');
  if (!replyBtn) return null;

  for (let i=0; i<replyBtn.length; i++){
    replyBtn[i].addEventListener('click', function(e){
      const replyForm = e.target.parentNode.firstElementChild;
      replyForm.removeAttribute('style', 'display:none;');
      this.setAttribute('style', 'display:none;');
    });
  };
  for (let o=0; o<replyPostBtn.length; o++){
    replyPostBtn[o].addEventListener('click', function (e) {
      const replyForm = e.target.closest('.reply-form');
      const replyBtn = document.getElementsByClassName('reply-btn');
      replyForm.setAttribute('style', 'display:none;');
      replyBtn[o].removeAttribute('style', 'display:none;');
    })
  }
});