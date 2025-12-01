function validateRegister(form) {
    const username = form.username.value.trim();
    const password = form.password.value.trim();
    const nickname = form.nickname.value.trim();
    if (!username || !password || !nickname) {
        alert('모든 필드를 입력하세요.');
        return false;
    }
    if (password.length < 6) {
        alert('비밀번호는 6자 이상이어야 합니다.');
        return false;
    }
    return true;
}

function validateTip(form) {
    if (form.title.value.trim().length < 5) {
        alert('제목은 5자 이상 작성해야 합니다.');
        return false;
    }
    if (form.content.value.trim().length < 10) {
        alert('내용은 10자 이상 작성하세요.');
        return false;
    }
    return true;
}

function validateItem(form) {
    const file = form.image.files[0];
    if (file) {
        const ext = file.name.split('.').pop().toLowerCase();
        if (!['jpg', 'jpeg', 'png'].includes(ext)) {
            alert('jpg/png 파일만 업로드할 수 있습니다.');
            return false;
        }
        const maxSize = 5 * 1024 * 1024;
        if (file.size > maxSize) {
            alert('파일은 5MB 이하만 가능합니다.');
            return false;
        }
    }
    return true;
}
