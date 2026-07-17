# Yazi CSV 미리보기 및 Sheets 열기 설계

## 목표

Yazi에서 CSV 파일을 선택하면 오른쪽 미리보기 창에 읽기 쉬운 표를 표시하고, Enter로 열 때는 이미 설치된 `sheets` 터미널 스프레드시트 앱을 실행한다.

## 범위

- 포함: `*.csv` 파일의 표 형태 미리보기와 `sheets` opener 연결
- 제외: `.xls`, `.xlsx`, CSV 편집 UI를 미리보기 창에 임베드하는 기능

## 설계

1. `dot_config/yazi/plugins/csv-preview.yazi/`에 로컬 Yazi previewer를 둔다.
2. previewer는 Python 표준 라이브러리의 `csv` 모듈을 사용해 CSV를 텍스트 표로 렌더링한다. 별도 Python 패키지는 설치하지 않는다.
3. 출력은 처음 30행·최대 8열로 제한하고, 셀의 줄바꿈은 공백으로 바꾸며 긴 값은 말줄임표로 자른다. UTF-8 BOM은 제거하고 잘못된 바이트는 치환해 미리보기 오류를 방지한다.
4. `yazi.toml`의 prepend previewer가 `*.csv`를 `csv-preview`로 연결한다. 같은 파일의 Enter 동작은 `sheets "$@"`를 block 모드로 실행하는 opener가 담당한다.
5. CSV 파싱 실패나 빈 파일은 오류로 종료하지 않고 설명 문구를 보여 준다. `sheets` 실행은 기존 Yazi terminal opener와 같이 사용자가 종료할 때까지 기다린다.

## 검증

1. 쉼표·따옴표·UTF-8 BOM을 포함한 CSV에서 표 헤더와 행이 기대대로 보인다.
2. 빈 CSV와 손상된 UTF-8 CSV는 Yazi를 종료시키지 않고 안내 문구를 보인다.
3. 실제 Yazi 세션에서 오른쪽 미리보기와 Enter 후 `sheets` 실행을 확인한다.
4. `chezmoi apply` 뒤 소스·배포 설정이 일치하는지 확인한다.
