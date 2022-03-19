import consumer from "./consumer"

if(location.pathname.match(/\/group_posts\/\d/)){
  consumer.subscriptions.create({
    channel: "CommentGroupChannel",
    group_post_id: location.pathname.match(/\d+/)[0]
    }, {

    connected() {
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      const replyHtml = () => {
        const html = `
        <div class="reply">
          <p class="reply-content"><img src="${data.avatar}" style="width: 25px; height: 25px;"><span>${data.user.nickname}</span></p>
          <div class="reply-text">
            <p class="reply-text-p">${data.comment.text}</p>
          </div>
        </div>`;
        const reply = document.getElementById(`replies${data.comment.parent_id}`);
        reply.insertAdjacentHTML('beforeend', html)
        const replyForm = document.getElementById(`reply-form${data.comment.parent_id}`)
        replyForm.reset();
      };

      const commentHtml = () => {
        const html = `
        <div class="comment">
          <div class="comment-avatar-box">
            <img src="${data.avatar}" style="width: 25px; height: 25px;">
          </div>
          <div class="comment-text-box">
            <p class="comment-nickname">${data.user.nickname}</p>
            <p class="comment-text">${data.comment.text}<p>
            <div class="comment-text-bottom-box">
              <div class="comment-delete-p">
              </div>
              <div class="comment-delete-btn-box btn">
              </div>
              <p class="reply-btn-p btn"><a class="reply-btn" style="cursor: pointer;">返信</a></p>
            </div>
            <div class="reply-form-area">
              <div class="reply-form" style="display: none;">
                <form id="reply-form${data.comment.id}" action="/posts/${data.comment.commentable_id}/comments" accept-charaset="UTF-8" data-remote="true" method="post">
                  <input type="hidden" name="comment[parent_id]" value="${data.comment.id}">
                  <textarea name="comment[text]" class="reply-form-text-area"></textarea>
                  <div class="actions">
                    <input type="submit" name="commit" class="reply-post-btn" value="返信する" data-disable-with="返信する">
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>
        <div id="replies${data.comment.id}" class="reply-box">
        </div>`;
        const comment = document.getElementById("comments");
        comment.insertAdjacentHTML('beforeend', html)
        const commentForm = document.getElementById('comment-form');
        commentForm.reset();
      };

      if (data.comment.text !== '') {
        if (data.comment.parent_id === null) {
          commentHtml();
        } else {
          replyHtml();
        }
      };
    }
  });
}