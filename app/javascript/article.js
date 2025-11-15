// likes.jsおよびcomments.jsでエクスポート”された関数"initLikes""initComments"をそれぞれインポート
import { initLikes } from "modules/likes";
import { initComments } from "modules/comments";

// ページがロードされたときに実行する処理
document.addEventListener("turbo:load", () => {
  // 記事詳細ページの#article-showを取得
  const articleShow = document.getElementById("article-show")
  if (!articleShow) return // 他のページでは処理をスキップ
  // #article-showのdata属性から記事IDを取得
  const articleId = articleShow.dataset.articleId
  // CSRF対策トークンの値を取得(他サイトからの不正なリクエストを防ぐためのセキュリティ対策)
  const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content'); // ?.getAttribute():metaタグが無いページでエラーを出さないようにする

  // likes.jsおよびcomments.jsで定義されたいいね・コメント入力の処理を実行する
  initLikes(articleId, csrfToken);
  initComments(articleId, csrfToken);
});
