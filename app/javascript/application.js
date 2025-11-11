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
    document.querySelector(".inactive-heart")?.classList.add("hidden"); // 「いいねしていない」状態のハートを確実に隠すために追加
  } else {
    // ハートマークを非表示にする
    document.querySelector('.inactive-heart')?.classList.remove('hidden')
    document.querySelector(".active-heart")?.classList.add("hidden"); // 「いいねしている」状態のハートを確実に隠すために追加
  }
}
//サーバーにいいね済みかを非同期で問い合わせ、ハートマークの表示を更新する
document.addEventListener("turbo:load", () => {
  //app/views/articles/show.html.hamlの#article-showを取得
  const articleShow = document.getElementById("article-show")
	if (!articleShow) return // 他のページでは処理をスキップ
  // #article-showのdata属性から記事IDを取得
  const articleId = articleShow.dataset.articleId
	// CSRF対策トークンの値を取得(他サイトからの不正なリクエストを防ぐためのセキュリティ対策)
  const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
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
  //「いいね」を押すためのクリックイベント
  document.querySelector(".inactive-heart").addEventListener("click", () => {
			// 「いいね」登録用のリクエストをサーバーに送る
      fetch(`/articles/${articleId}/like`, {
        method: "POST",// HTTPメソッドはPOST
        headers: {
          "X-CSRF-Token": csrfToken,// CSRF対策トークンを送信
          "Content-Type": "application/json",// リクエストボディがJSONであることを明示
          Accept: "application/json",// サーバーからJSONで返してもらう
        },
      })
				// サーバーからのレスポンスをJSONとして処理
        .then((response) => {
          if (!response.ok) throw new Error(`HTTP error ${response.status}`);
          return response.json();
        })
				// サーバーからのJSONを受け取って処理
        .then((data) => {
          // サーバーが { status: "ok" } を返したら、いいねを表示する
          if (data.status === "ok") {
            handleHeartDisplay(true);
          }
        })
        // 通信エラー（サーバーダウンやネットワークエラーなど）の処理
        .catch((error) => {
          console.error(error);
        });
    });

  // 「いいね」を削除するためのクリックイベント
  document.querySelector(".active-heart").addEventListener("click", () => {
			// 「いいね」削除用のリクエストをサーバーに送る
      fetch(`/articles/${articleId}/like`, {
        method: "DELETE",// HTTPメソッドはDELETE
        headers: {
          "X-CSRF-Token": csrfToken,// CSRF対策トークンを送信
          Accept: "application/json",// サーバーからJSONで返してもらう
        },
      })
				// サーバーからのレスポンスをJSONとして処理
        .then((response) => {
          if (!response.ok) throw new Error(`HTTP error ${response.status}`);
          return response.json();
        })
				// サーバーからのJSONを受け取って処理
        .then((data) => {
					// サーバーが { status: "ok" } を返したら、いいねを非表示にする
          if (data.status === "ok") {
            handleHeartDisplay(false);
          }
        })
        // 通信エラー（サーバーダウンやネットワークエラーなど）の処理
        .catch((error) => {
          console.error(error);
        });
    });
})
