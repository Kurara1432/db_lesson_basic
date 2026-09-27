-- ・Q1
create table departments(
department_id int unsigned not null auto_increment PRIMARY KEY,
name VARCHAR(20) not null ,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Q1追加
-- ⓵department_id、⓶created_at、⓷updated_at
-- ⓵はAUTO_INCREMENTにおいては自動で数字を入力されるため
-- ⓶、⓷は現在の時刻がCURRENT_TIMESTAMPにより自動で入力され、⓷に関してはON UPDATEによりレコードの更新ごとに現在の時刻が入力されるため

-- ・Q2
alter table people add departments_id int unsigned after email;

-- ・Q3
-- ※departments
insert into departments (name)
values
('営業'),
('開発'),
('経理'),
('人事'),
('情報システム');

-- ※people
insert into people(name, email, departments_id, age,gender)
values
('山田 太郎', 'taro.yamada@example.com', 1, 24, 1),
('佐藤 花子', 'hanako.sato@example.com', 1, 31, 2),
('鈴木 恒一', 'koichi.suzuki@example.com', 1, 27, 1),
('高橋 美咲', 'misaki.takahashi@example.com', 2, 22, 2),
('伊藤 健太', 'kenta.ito@example.com', 2, 35, 1),
('渡辺 彩', 'aya.watanabe@example.com', 2, 29, 2),
('中村 翔', 'sho.nakamura@example.com', 2, 41, 1),
('小林 由奈', 'yuna.kobayashi@example.com', 3, 26, 2),
('加藤 大輔', 'daisuke.kato@example.com', 4, 33, 1),
('吉田 愛', 'ai.yoshida@example.com', 5, 38, 2);


-- ※reports
insert into reports(person_id,content)
values
(1,'本日は業務の流れを確認しながら、担当作業を進めました。'),
(2,'少し緊張しましたが、落ち着いて取り組めました。'),
(7,'本日は昨日の作業内容を振り返り、効率を意識して業務を行いました。'),
(8,'昨日よりスムーズに作業できてよかったです。'),
(9,'本日は細かい部分まで確認することを意識して、ミスのないよう作業しました。'),
(10,'丁寧に確認することの大切さを感じました。'),
(3,'本日は周囲と確認を取りながら、担当している業務を進めました。'),
(4,' 周りと協力することで安心して作業できました。'),
(7,'本日は時間配分を考えながら、予定していた作業を順番に進めました。'),
(8,'計画的に進めると作業しやすいと感じました。');


-- ・Q4
update people set departments_id = 1 where person_id = 1;
update people set departments_id = 2 where person_id = 2;
update people set departments_id = 3 where person_id = 3;
update people set departments_id = 4 where person_id = 4;
update people set departments_id = 5 where person_id = 6;
-- SELECT * FROM people WHERE person_id = 1;　これで一個目がちゃんと追加できてるか確認して、
-- MariaDB [db_lesson]> select * from people; これで最終チェックしました。

-- ・Q5
select name, age from people where gender = 1 order by age desc;

-- ・Q6
-- 「people」というテーブルから、「name」、「email」、「age」カラムを、「departments_id」のカラムからレコードが1の人限定で、「created_at」の昇順で並び替えたものを表示する。

-- ・Q7
-- それぞれ男性、女性事の集計
select name from people where age >= 20 and age <30 and gender  = 2 ;
select name from people where age >= 40 and age <50 and gender  = 1 ;
-- 一括で集計する方法
select name from people where ( age >= 20 and age <30 and gender = 2 ) or ( age >= 40 and age<50 and gender = 1 );

-- ・Q8
select * from people where departments_id = 1 order by age ;

-- ・Q9
select AVG(age) AS average_age from people where departments_id = 2 and gender = 2 ;

-- ・Q10
select people.name, departments.name, reports.content from people inner join reports on people.person_id = reports.person_id inner join departments on people.departments_id = departments.department_id;
-- まぁまぁ苦戦しました…　それぞれのテーブルを表示して、スペルミスないか確認しました…
-- ↓
select people.name, departments.name, reports.content from people inner join reports on people.person_id = reports.person_id inner join departments on people.departments_id = departments.department_id where reports.content is not null ;
-- nullを除外するのを忘れてました。

-- Q10追加
-- 内部結合の場合、結合相手がnullの場合、そもそもそのレコードは無視されるため

-- ・Q11
select p.name from people p left outer join reports r using (person_id) where content is null;

-- Q11追加
-- left outer joinは左に書かれている、people基準にしてreportsを結合するため、peopleからみてreports側の入力がないものをnullで返す。
-- RIGHT OUTER JOINは右に書かれている、（例）select r.content from people p right outer join reports r using (person_id) where name is null;の場合reports基準にしてpeopleと結合するため、今回でいえばレポートは書いているが名前を登録していない人のcontentを表示する。