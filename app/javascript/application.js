// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "trix"
import "@rails/actiontext"

// いいね状態に応じてハートマークの表示を切り替える関数
const handleHeartDisplay = (hasLiked) => {
  // もし「いいね済み（hasLiked が true）」なら
  if (hasLiked) {
    // ハートマークを表示する
    document.querySelector('.active-heart')?.classList.remove('hidden')
  } else {
    // ハートマークを非表示にする
    document.querySelector('.inactive-heart')?.classList.remove('hidden')
  }
}
//サーバーにいいね済みかを非同期で問い合わせ、ハートマークの表示を更新する
document.addEventListener("turbo:load", () => {
  //app/views/articles/show.html.hamlの#article-showを取得
  const articleShow = document.getElementById("article-show")
	if (!articleShow) return // 他のページでは処理をスキップ

  // #article-showのdata属性から記事IDを取得
  const articleId = articleShow.dataset.articleId

  // fetchでGETリクエストを送信
  fetch(`/articles/${articleId}/like`, {
    headers: {
      Accept: "application/json"
    }
  })
    // サーバーからのレスポンスをJSONとして処理
    .then((response) => {
      if (!response.ok) throw new Error(`HTTP error ${response.status}`)
      return response.json()
    })
    // 正常にレスポンスが返ってきたときの処理
    .then((data) => {
			// JSONデータの受信に成功したら、いいね状態を取得して表示を更新
      handleHeartDisplay(data.hasLiked) // サーバーが返した { hasLiked: true/false } の値を使用
    })
    // 通信エラー（サーバーダウンやネットワークエラーなど）の処理
    .catch((error) => {
      console.error(error)
    })
})
