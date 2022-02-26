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
      console.log(data);
      const replyHtml = () => {
        const html = `
        <div class="reply">
          <p class="reply-content"> ${data.user.nickname} : ${data.comment.text}</p>
        </div>`;
        const reply = document.getElementById(`replies${data.comment.parent_id}`);
        reply.insertAdjacentHTML('beforeend', html)
        const replyForm = document.getElementById(`reply-form${data.comment.parent_id}`)
        replyForm.reset();
      };

      const commentHtml = (user_id, comment_user_id) => {
        if (user_id === comment_user_id) {
          const html = `
          <div class="comment">
            <p>${data.user.nickname} ${data.comment.created_at}</p>
            <p>${data.comment.text}<p>
            <a rel="nofollow" data-method="delete" href="/posts/${data.comment.id}/comments/${data.comment.commentable_id}" class="comment-dele">
              <i class="fas fa-trash-alt"></i>
            </a>
          </div>
            <div id="replies${data.comment.id}">
              <div class="reply">
                <p class="reply-content"></p>
              </div>
            </div>
            <div class="reply-form-area">
              <div class="reply-form" style="display: none;">
                <form id="reply-form${data.comment.id}" action="/posts/${data.comment.commentable_id}/comments" accept-charaset="UTF-8" data-remote="true" method="post">
                  <input type="hidden" name="comment[parent_id]" value="${data.comment.id}">
                  <textarea name="comment[text]"></textarea>
                  <div class="actions">
                    <input type="submit" name="commit" value="返信する" data-disable-with="返信する">
                  </div>
                </form>
              </div>
              <a class="reply-btn" style="cursor: pointer;">返信</a>
            </div>`;
          const comment = document.getElementById("comments");
          comment.insertAdjacentHTML('beforeend', html)
          const commentForm = document.getElementById('comment-form');
          commentForm.reset();
        } else {
          const html = `
          <div class="comment">
            <p>${data.user.nickname} ${data.comment.created_at}</p>
            <p>${data.comment.text}<p>
          </div>
            <div id="replies${data.comment.id}">
              <div class="reply">
                <p class="reply-content"></p>
              </div>
            </div>
            <div class="reply-form-area">
              <div class="reply-form" style="display: none;">
                <form id="reply-form${data.comment.id}" action="/posts/${data.comment.commentable_id}/comments" accept-charaset="UTF-8" data-remote="true" method="post">
                  <input type="hidden" name="comment[parent_id]" value="${data.comment.id}">
                  <textarea name="comment[text]"></textarea>
                  <div class="actions">
                    <input type="submit" name="commit" value="返信する" data-disable-with="返信する">
                  </div>
                </form>
              </div>
              <a class="reply-btn" style="cursor: pointer;">返信</a>
            </div>`;
          const comment = document.getElementById("comments");
          comment.insertAdjacentHTML('beforeend', html)
          const commentForm = document.getElementById('comment-form');
          commentForm.reset();
        }
      };

      if (data.comment.parent_id === null) {
        commentHtml(data.user.id, data.comment.user_id);
      } else {
        replyHtml();
      }
    }
  });
}