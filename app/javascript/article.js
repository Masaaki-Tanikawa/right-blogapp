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
// 「コメントを追加」ボタンで入力フォームを開く関数
const handleCommentForm = () => {
	document.querySelectorAll('.show-comment-form').forEach((btn) => {
    btn.addEventListener('click', () => {
      btn.classList.add('hidden')
      document.querySelector('.comment-text-area')?.classList.remove('hidden') //.comment-text-areaが存在しないときにエラーを出さないようにする
    })
  })
}
// 「コメント一覧」にコメントを追加する関数
const appendNewComment = (comment) => {
		// コメント内容をHTML要素として .comments-container に挿入
		document.querySelector('.comments-container')?.insertAdjacentHTML(
			'beforeend',// 要素の末尾に追加
			`<div class="article_comment"><p>${comment.content}</p></div>`
		)
}
// ページがロードされたときに実行する処理を記述
document.addEventListener("turbo:load", () => {
  // 記事詳細ページの#article-showを取得
  const articleShow = document.getElementById("article-show")
  if (!articleShow) return // 他のページでは処理をスキップ
  // #article-showのdata属性から記事IDを取得
  const articleId = articleShow.dataset.articleId
  // CSRF対策トークンの値を取得(他サイトからの不正なリクエストを防ぐためのセキュリティ対策)
  const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content'); // ?.getAttribute():metaタグが無いページでエラーを出さないようにする

  //サーバーにいいね済みかを非同期で問い合わせ、ハートマークの表示を更新する
  // fetchでGETリクエストを送信
  fetch(`/articles/${articleId}/like`, {
    headers: {
      Accept: "application/json"
    }
  })
    // サーバーからのレスポンスをJSONとして処理
    .then((response) => {
      if (!response.ok) throw new Error(`HTTP error ${response.status}`)
      return response.json();
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
  document.querySelector(".inactive-heart")?.addEventListener("click", () => {
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
  document.querySelector(".active-heart")?.addEventListener("click", () => {
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

  // サーバーからコメント情報を取得して、一覧表示する
  // fetchでGETリクエストを送信
  fetch(`/articles/${articleId}/comments`, {
    // method: "GET" は、省略して問題なし
    headers: {
      Accept: "application/json" // サーバーからJSONを受け取ることを明示
      // "X-CSRF-Token": csrfToken,は、GETメソッドのため不要
    }
  })
    // サーバーからのレスポンスをJSONとして処理
    .then((response) => {
      if (!response.ok) throw new Error(`HTTP error ${response.status}`);
      return response.json();
    })
    // サーバーから受け取ったコメント情報を処理
    .then((comments) => {
      // 各コメントをループ処理してHTMLに追加
      comments.forEach((comment) => {
				// コメントを一覧に追加する関数を実行
				appendNewComment(comment)
      })
    })
    // 通信エラー（サーバーダウンやネットワークエラーなど）の処理
    .catch((error) => {
      console.error(error)
    })

  // コメント入力フォームを表示させる関数を実行
	handleCommentForm()

  // 「コメントを追加」ボタンを押して、フォームに入力したコメントを送信する
  document.querySelector('.add-comment-button')?.addEventListener('click', () => {
      // コメント入力欄の値を取得
      const content = document.getElementById('comment_content').value;
      // コメントに値がない場合、アラート表示
      if (!content) {
        window.alert('コメントを入力してください');
        return;
      }
      // コメント登録用のリクエストをサーバーに送る
      fetch(`/articles/${articleId}/comments`, {
        method: "POST",// HTTPメソッドはPOST
        headers: {
          "X-CSRF-Token": csrfToken,// CSRF対策トークンを送信
          "Content-Type": "application/json",// リクエストボディがJSONであることを明示
          Accept: "application/json",// サーバーからJSONで返してもらう
        },
        // JavaScriptのオブジェクトをJSON文字列に変換
        body: JSON.stringify({
          comment: { content: content } // {comment: { content: "入力したコメント" }} をJSONで渡す
        }),
      })
        // サーバーからのレスポンスをJSONとして処理
        .then((response) => {
          if (!response.ok) throw new Error(`HTTP error ${response.status}`);
          return response.json();
        })
        // サーバーから受け取ったコメント情報を処理
        .then((comment) => {
					// コメントを一覧に追加する関数を実行
					appendNewComment(comment)
          // コメント入力フォームをリセット
          document.getElementById('comment_content').value = '';
        })
        // 通信エラー（サーバーダウンやネットワークエラーなど）の処理
        .catch((error) => {
          console.error(error)
        })
    });

});
