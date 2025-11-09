// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "trix"
import "@rails/actiontext"

//サーバーにいいね済みかを非同期で問い合わせ、結果をコンソールに出力する
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
      console.log(data)
			// http://localhost:3000/articles/XX のconsoleにアクセスすると、”[hasLiked":true(false)]”が表示される
    })
    // 通信エラー（サーバーダウンやネットワークエラーなど）の処理
    .catch((error) => {
      console.error(error)
    })
})

