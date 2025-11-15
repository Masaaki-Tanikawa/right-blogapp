// 「コメントを追加」ボタンで入力フォームを開く関数(article.js内のコードをそのまま移動)
const handleCommentForm = () => {
	document.querySelectorAll('.show-comment-form').forEach((btn) => {
		btn.addEventListener('click', () => {
			btn.classList.add('hidden')
			document.querySelector('.comment-text-area')?.classList.remove('hidden') //.comment-text-areaが存在しないときにエラーを出さないようにする
		})
	})
}
// 「コメント一覧」にコメントを追加する関数(article.js内のコードをそのまま移動)
const appendNewComment = (comment) => {
	document.querySelector('.comments-container')?.insertAdjacentHTML(
		'beforeend',
		`<div class="article_comment"><p>${comment.content}</p></div>`
	)
}

// article.jsから受け取った「記事ID」と「CSRFトークン」で、コメント入力・表示の処理を実行する
// ※ exportで関数や変数を外部ファイルで使えるようにする(article.js内のコードをそのまま移動)
export const initComments = (articleId, csrfToken) => {
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
			});
	})
}