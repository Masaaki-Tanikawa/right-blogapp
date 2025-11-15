// いいね状態に応じてハートマークを切り替える(article.js内のコードをそのまま移動)
const handleHeartDisplay = (hasLiked) => {
	if (hasLiked) {
		document.querySelector('.active-heart')?.classList.remove('hidden')
		document.querySelector('.inactive-heart')?.classList.add('hidden')
	} else {
		document.querySelector('.inactive-heart')?.classList.remove('hidden')
		document.querySelector('.active-heart')?.classList.add('hidden')
	}
}

// article.jsから受け取った「記事ID」と「CSRFトークン」で、いいね切り替えの処理を実行する
// ※ exportで関数や変数を外部ファイルで使えるようにする(article.js内のコードをそのまま移動)
export const initLikes = (articleId, csrfToken) => {
	
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
	})

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
	})
}
