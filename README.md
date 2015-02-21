# foot

[풋토](http://m.sports.naver.com/radio/list.nhn?programId=WfootballNtalk) 를 오디오 태그(`<audio>`)로 다시 듣자!!

## 왜?

* 모바일에서 네이버 라디오는 비디오 플레이어로 재생되기 때문에 재생되는 동안 다른 탭을 사용할 수 없음
* 생방송의 경우 `*.m3u8` (HLS) 로 서비스 되는데, `<audio>` 태그에서 재생이 불가능하다.
* 하지만 다시듣기의 경우 `*.m4a` 로 서비스 되며, 이는 `<audio>` 태그로 재생이 가능하다. 
* `<audio>` 태그로 음원을 재생하면, 방송을 들으면서 브라우져의 다른 탭을 사용할 수 있다.

## 어떻게?

* 방송 리스트를 얻어오는 API 는 [CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/Access_control_CORS) 옵션 때문에 다른 페이지에서 사용이 불가능 하다.
  * 웹 페이지 크롤링 서비스인 [kimono](https://www.kimonolabs.com) 를 활용해, 최근 10개 방송에 대한 정보를 가져오는 [API](https://www.kimonolabs.com/apis/3kplvmje) 작성
* [방송 페이지](http://m.sports.naver.com/radio/end.nhn?radioId=2284&programId=WfootballNtalk) 에서 다시듣기가 가능한 `*.m4a` 파일의 경로가 찾을 수 있다. 하지만 일정 시간이 지나면 접근이 차단된다. 때문에 일정시간마다 방송 페이지에 접속해 유효한 경로를 가져와야 한다.
  * 역시 [kimono](https://www.kimonolabs.com) 를 활용해 유효한 경로를 가져오는 [API](https://www.kimonolabs.com/apis/ciqlk7me) 작성

## Run

```
$ bower install
$ npm install
$ npm start
```

## See

[http://chitacan.github.io/foot](http://chitacan.github.io/foot)

## TODO

- [x] 마지막으로 들은 위치부터 재생하기
- [ ] 생방송 재생하기
- [ ] 페이지에 저장소, 피드백 url 추가
