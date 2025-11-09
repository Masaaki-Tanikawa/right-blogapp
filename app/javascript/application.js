// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "trix"
import "@rails/actiontext"

// ページをリロードせずにサーバーにGETリクエストを送る（結果はコンソールに出力）
document.addEventListener("turbo:load", () => {
  // .article_title 要素をクリックしたらサーバーにGETリクエスト
  document.querySelectorAll(".article_title").forEach((title) => {
    title.addEventListener("click", () => {
			// "/" に対してHTTPリクエストを送信する(レスポンスはHTML形式を指定)
      fetch("/", { headers: { Accept: "text/html" } })
				// サーバーからのレスポンスが正常に返ってきたら、HTTPステータスコードを表示
        .then((response) => {
          console.log("fetch OK:", response.status)
        })
				// 通信が失敗したら、エラー内容を表示（ネットワークエラー、サーバー停止など）
        .catch((error) => {
          console.error("fetch error:", error)
        })
    })
  })
})