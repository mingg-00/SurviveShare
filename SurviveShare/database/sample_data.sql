USE surviveshare;
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- 기존 샘플 데이터 제거 (재실행 시 중복 방지)
DELETE FROM recipe_steps
WHERE recipe_id IN (
    SELECT recipe_id
    FROM recipes
    WHERE session_id LIKE 'sample-session-%'
       OR name IN ('맛보장 라면 스프 볶음밥', '초간단 샤브샤브', '귀찮을 땐 순두부찌개')
);
DELETE FROM recipes
WHERE session_id LIKE 'sample-session-%'
   OR name IN ('맛보장 라면 스프 볶음밥', '초간단 샤브샤브', '귀찮을 땐 순두부찌개');
DELETE FROM items
WHERE session_id LIKE 'sample-session-%';
DELETE FROM tips
WHERE session_id LIKE 'sample-session-%';
DELETE FROM sessions
WHERE session_id LIKE 'sample-session-%';

-- 샘플 세션 생성
INSERT IGNORE INTO sessions(session_id, level_score) VALUES
('sample-session-1', 15),
('sample-session-2', 8),
('sample-session-3', 25),
('sample-session-4', 12),
('sample-session-5', 30),
('sample-session-6', 5),
('sample-session-7', 18),
('sample-session-8', 22),
('sample-session-9', 10),
('sample-session-10', 35);

-- 오늘의 꿀팁 10개
INSERT INTO tips(session_id, title, content, image_path, recommend_count, created_at) VALUES
('sample-session-1', '라면 끓일 때 계란 넣는 타이밍', '물이 끓기 시작하면 라면을 넣고, 1분 후 계란을 넣으면 완벽한 반숙 계란이 됩니다. 너무 일찍 넣으면 흰자만 익고 노른자가 딱딱해져요!', NULL, 5, NOW()),
('sample-session-2', '김치냉장고 없이 김치 보관법', '김치를 밀폐용기에 넣고 냉장고 문쪽에 보관하세요. 문을 자주 열어서 온도 변화가 있어도 김치가 잘 보관됩니다. 그리고 김치 위에 물을 조금 뿌려주면 더 오래 신선해요!', NULL, 3, DATE_SUB(NOW(), INTERVAL 1 DAY)),
('sample-session-3', '빨래 건조 시간 단축 꿀팁', '빨래를 돌릴 때 수건 2-3장을 함께 넣으면 수분을 빨아들여서 건조 시간이 훨씬 빨라집니다. 특히 겨울철에 유용해요!', NULL, 7, DATE_SUB(NOW(), INTERVAL 2 DAY)),
('sample-session-4', '싱크대 냄새 제거 방법', '배수구에 베이킹소다와 식초를 넣고 10분 기다린 후 뜨거운 물을 부으면 냄새가 확실히 사라집니다. 주 1회만 해도 효과가 좋아요!', NULL, 4, DATE_SUB(NOW(), INTERVAL 3 DAY)),
('sample-session-5', '전기요금 절약 팁', '냉장고는 벽에서 10cm 떨어뜨려 놓고, 냉동실은 70%만 채우면 효율이 좋아져요. 그리고 세탁기는 저녁 9시 이후에 돌리면 전기요금이 절약됩니다!', NULL, 6, DATE_SUB(NOW(), INTERVAL 4 DAY)),
('sample-session-6', '쌀벌레 방지법', '쌀통에 고추나 마늘을 넣어두면 벌레가 생기지 않아요. 그리고 쌀을 냉장고에 보관하면 더 오래 신선하게 유지됩니다!', NULL, 2, DATE_SUB(NOW(), INTERVAL 5 DAY)),
('sample-session-7', '옷장 공간 활용법', '옷걸이를 두 줄로 걸면 공간을 2배로 활용할 수 있어요. 그리고 계절 옷은 진공팩에 넣어서 보관하면 공간이 많이 절약됩니다!', NULL, 8, DATE_SUB(NOW(), INTERVAL 6 DAY)),
('sample-session-8', '간단한 집 청소 루틴', '매일 아침 10분만 투자해서 화장실 청소, 먼지 털기, 쓰레기 버리기를 하면 주말에 대청소할 필요가 없어요. 작은 습관이 큰 차이를 만듭니다!', NULL, 9, DATE_SUB(NOW(), INTERVAL 7 DAY)),
('sample-session-9', '음식물 쓰레기 냄새 제거', '음식물 쓰레기통 바닥에 신문지를 깔고, 위에 소금을 뿌려두면 냄새가 훨씬 줄어들어요. 그리고 매일 버리는 습관을 들이면 더 좋습니다!', NULL, 5, DATE_SUB(NOW(), INTERVAL 8 DAY)),
('sample-session-10', '혼자 살 때 필수템 추천', '전자레인지, 에어프라이어, 미니냉장고는 필수예요. 특히 에어프라이어는 요리 시간을 단축시켜주고, 전자레인지는 간단한 식사 준비에 최고입니다!', NULL, 12, DATE_SUB(NOW(), INTERVAL 9 DAY));

-- 최근 등록 물품 10개
INSERT INTO items(session_id, name, description, image_path, meet_time, meet_place, created_at) VALUES
('sample-session-1', '에어프라이어', '3.5L 용량의 에어프라이어입니다. 튀김, 구이, 데우기 모두 가능해요. 상태 양호합니다!', 'uploads/airfryer.jpg', DATE_ADD(NOW(), INTERVAL 1 DAY), '우리동네 커뮤니티 센터 1층', NOW()),
('sample-session-2', '다리미판', '접이식 다리미판입니다. 사용감 적고 보관하기 편해요. 필요하신 분 가져가세요!', 'uploads/darimipan.jpg', DATE_ADD(NOW(), INTERVAL 2 DAY), '역삼역 3번 출구 앞', DATE_SUB(NOW(), INTERVAL 1 DAY)),
('sample-session-3', '청소기', '무선 청소기입니다. 배터리 상태 양호하고 필터도 새것으로 교체했어요. 깨끗하게 사용했습니다!', 'uploads/bacummcleaner.jpg', DATE_ADD(NOW(), INTERVAL 3 DAY), '집 앞 카페 테라스', DATE_SUB(NOW(), INTERVAL 2 DAY)),
('sample-session-4', '전자레인지', '20L 용량의 전자레인지입니다. 데우기, 해동 모두 잘 됩니다. 상태 좋아요!', 'uploads/wave.jpg', DATE_ADD(NOW(), INTERVAL 4 DAY), '시청 도서관 입구', DATE_SUB(NOW(), INTERVAL 3 DAY)),
('sample-session-5', '책상', 'IKEA 책상입니다. 조립식이고 상태 양호해요. 이사 가면서 내놓습니다!', 'uploads/table.jpg', DATE_ADD(NOW(), INTERVAL 5 DAY), '중앙공원 분수대 앞', DATE_SUB(NOW(), INTERVAL 4 DAY)),
('sample-session-6', '의자', '의자 좌석 쿠션 상태 좋고, 다리도 튼튼해요. 필요하시면 연락주세요!', 'uploads/chair.jpg', DATE_ADD(NOW(), INTERVAL 6 DAY), '커뮤니티 라운지 2층', DATE_SUB(NOW(), INTERVAL 5 DAY)),
('sample-session-7', '선풍기', '스탠드형 선풍기입니다. 3단 풍량 조절 가능하고, 틸팅 기능도 있어요. 여름 필수템!', 'uploads/pen.jpg', DATE_ADD(NOW(), INTERVAL 7 DAY), '한강공원 자전거 대여소 앞', DATE_SUB(NOW(), INTERVAL 6 DAY)),
('sample-session-8', '전기포트', '1.7L 용량의 전기포트입니다. 물 끓이는 속도 빠르고, 자동 차단 기능도 있어요!', 'uploads/pot.jpg', DATE_ADD(NOW(), INTERVAL 8 DAY), '학교 후문 편의점 앞', DATE_SUB(NOW(), INTERVAL 7 DAY)),
('sample-session-9', '옷걸이 50개', '옷걸이 50개 묶음입니다. 플라스틱 재질이고 상태 좋아요. 옷장 정리하시는 분들께 추천!', 'uploads/clothesgori.jpg', DATE_ADD(NOW(), INTERVAL 9 DAY), '우리집 1층 로비', DATE_SUB(NOW(), INTERVAL 8 DAY)),
('sample-session-10', '행거', '옷걸이형 행거입니다. 이동식이고 바퀴도 달려있어요. 공간 활용하기 좋습니다!', 'uploads/hanger.jpg', DATE_ADD(NOW(), INTERVAL 10 DAY), '동네 주민센터 앞 벤치', DATE_SUB(NOW(), INTERVAL 9 DAY));

-- 레시피 3개 (가격 정보 및 이미지 경로 포함)
INSERT INTO recipes(session_id, name, ingredients, time_required, price, image_path, created_at) VALUES
('sample-session-1', '맛보장 라면 스프 볶음밥', '밥 1공기\n라면 스프 1봉지\n식용유 1스푼', 5, 1000, 'uploads/ramenbob.png', NOW()),
('sample-session-2', '초간단 샤브샤브', '샤브샤브용 고기 200g\n야채(배추, 당근, 버섯 등)\n샤브샤브 국물 500ml', 15, 5000, 'uploads/shabushabu.png', DATE_SUB(NOW(), INTERVAL 1 DAY)),
('sample-session-3', '귀찮을 땐 순두부찌개', '순두부 1팩\n대파 1대\n고춧가루 1스푼\n물 300ml', 10, 5000, 'uploads/tofu.png', DATE_SUB(NOW(), INTERVAL 2 DAY));

-- 레시피 조리 단계 (레시피 삽입 후 실행)
-- 맛보장 라면 스프 볶음밥 조리 단계
INSERT INTO recipe_steps(recipe_id, step_number, instruction) 
SELECT recipe_id, 1, '팬을 중불에 올리고 식용유 1스푼을 두른다' FROM recipes WHERE name = '맛보장 라면 스프 볶음밥' LIMIT 1;
INSERT INTO recipe_steps(recipe_id, step_number, instruction) 
SELECT recipe_id, 2, '팬이 따뜻해지면 밥 1공기를 넣고 2-3분간 볶는다' FROM recipes WHERE name = '맛보장 라면 스프 볶음밥' LIMIT 1;
INSERT INTO recipe_steps(recipe_id, step_number, instruction) 
SELECT recipe_id, 3, '라면 스프 1봉지를 넣고 골고루 섞어가며 1분 더 볶는다' FROM recipes WHERE name = '맛보장 라면 스프 볶음밥' LIMIT 1;
INSERT INTO recipe_steps(recipe_id, step_number, instruction) 
SELECT recipe_id, 4, '완성! 그릇에 담아서 먹는다' FROM recipes WHERE name = '맛보장 라면 스프 볶음밥' LIMIT 1;

-- 초간단 샤브샤브 조리 단계
INSERT INTO recipe_steps(recipe_id, step_number, instruction) 
SELECT recipe_id, 1, '샤브샤브 국물 팩을 냄비에 넣고 물 500ml를 부어 끓인다' FROM recipes WHERE name = '초간단 샤브샤브' LIMIT 1;
INSERT INTO recipe_steps(recipe_id, step_number, instruction) 
SELECT recipe_id, 2, '국물이 끓으면 샤브샤브용 고기 200g을 넣고 살짝 익힌다' FROM recipes WHERE name = '초간단 샤브샤브' LIMIT 1;
INSERT INTO recipe_steps(recipe_id, step_number, instruction) 
SELECT recipe_id, 3, '고기가 익으면 배추, 당근, 버섯 등 준비한 야채를 넣는다' FROM recipes WHERE name = '초간단 샤브샤브' LIMIT 1;
INSERT INTO recipe_steps(recipe_id, step_number, instruction) 
SELECT recipe_id, 4, '야채가 적당히 익으면 불을 끄고 그릇에 담아서 먹는다' FROM recipes WHERE name = '초간단 샤브샤브' LIMIT 1;

-- 귀찮을 땐 순두부찌개 조리 단계
INSERT INTO recipe_steps(recipe_id, step_number, instruction) 
SELECT recipe_id, 1, '냄비에 물 300ml를 넣고 끓인다' FROM recipes WHERE name = '귀찮을 땐 순두부찌개' LIMIT 1;
INSERT INTO recipe_steps(recipe_id, step_number, instruction) 
SELECT recipe_id, 2, '물이 끓으면 순두부 1팩을 넣고 국자로 적당히 자른다' FROM recipes WHERE name = '귀찮을 땐 순두부찌개' LIMIT 1;
INSERT INTO recipe_steps(recipe_id, step_number, instruction) 
SELECT recipe_id, 3, '대파 1대를 썰어서 넣고 고춧가루 1스푼을 넣는다' FROM recipes WHERE name = '귀찮을 땐 순두부찌개' LIMIT 1;
INSERT INTO recipe_steps(recipe_id, step_number, instruction) 
SELECT recipe_id, 4, '5분 정도 끓이다가 계란 1개를 풀어 넣고 1분 더 끓인다' FROM recipes WHERE name = '귀찮을 땐 순두부찌개' LIMIT 1;
INSERT INTO recipe_steps(recipe_id, step_number, instruction) 
SELECT recipe_id, 5, '완성! 그릇에 담아서 먹는다' FROM recipes WHERE name = '귀찮을 땐 순두부찌개' LIMIT 1;
