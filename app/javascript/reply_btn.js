document.addEventListener('click', function(e) {
  if (e.target.classList.contains('reply-btn')) {
    const replyForm = e.target.closest('.comment-text-box').lastElementChild.firstElementChild;
    if (replyForm.style.display==="none"){
      replyForm.style.display ="block";
      replyForm.firstElementChild.lastElementChild.firstElementChild.disabled =false;
      e.target.style.display ="none";
    }
  }
  if (e.target.classList.contains('reply-post-btn')) {
    e.target.closest('.reply-form').style.display ="none";
    e.target.closest('.reply-form-area').previousElementSibling.lastElementChild.firstElementChild.style.display ="block";
  }
}, false);