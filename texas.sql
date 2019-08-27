set names utf8;
set foreign_key_checks=0;

drop database if exists texas;
create database if not exists texas;
use texas;
/*会員情報テーブル*/
create table user_info(
id int not null primary key auto_increment,/*ID*/
user_id varchar(16) unique not null,/*ユーザーID*/
password varchar(16) not null,/*パスワード*/
family_name varchar(32) not null,/*姓*/
first_name varchar(32) not null,/*名*/
family_name_kana varchar(32) not null,/*姓かな*/
first_name_kana varchar(32) not null,/*名かな*/
sex tinyint not null default 0,/*性別*/
email varchar(32),/*メールアドレス*/
status tinyint default 0,/*ステータス*/
logined tinyint not null default 0,/*ログインフラグ*/
regist_date datetime,/*登録日時*/
update_date datetime/*更新日時*/
);
/*商品情報テーブル*/
create table product_info(
id int not null primary key auto_increment,/*ID*/
product_id int unique not null,/*商品ID*/
product_name varchar(100) unique not null,/*商品名*/
product_name_kana varchar(100) unique not null,/*商品名かな*/
product_description varchar(255) not null,/*商品詳細*/
category_id int not null,/*カテゴリID*/
price int not null,/*値段*/
image_file_path varchar(100) not null,/*画像ファイルパス*/
image_file_name varchar(50) not null,/*画像ファイル名*/
release_date datetime,/*発売年月*/
release_company varchar(50),/*発売会社*/
status tinyint default 1,/*ステータス*/
regist_date datetime,/*登録日時*/
update_date datetime,/*更新一時*/
foreign key (category_id) references m_category(category_id)/*外部キー制約*/
);
/*カート情報テーブル*/
create table cart_info(
id int not null primary key auto_increment,/*ID*/
user_id varchar(16) not null,/*ユーザーID*/
product_id int not null,/*商品ID*/
product_count int not null,/*個数*/
regist_date datetime,/*登録日時*/
update_date datetime,/*更新日時*/
foreign key (product_id) references product_info(product_id)/*外部キー制約*/
);
/*購入履歴情報テーブル*/
create table purchase_history_info(
id int not null primary key auto_increment,/*ID*/
user_id varchar(16) not null,/*ユーザーID*/
product_id int not null,/*商品ID*/
product_count int,/*個数*/
price int not null,/*値段*/
destination_id int,/*宛先情報ID*/
regist_date datetime,/*登録日時*/
update_date datetime,/*更新日時*/
foreign key (user_id) references user_info(user_id),/*外部キー制約*/
foreign key (product_id) references product_info(product_id)/*外部キー制約*/
);
/*宛先情報テーブル*/
create table destination_info(
id int not null primary key auto_increment,/*ID*/
user_id varchar(16) not null,/*ユーザーID*/
family_name varchar(32) not null,/*姓*/
first_name varchar(32) not null,/*名*/
family_name_kana varchar(32) not null,/*姓かな*/
first_name_kana varchar(32) not null,/*名かな*/
email varchar(32) not null,/*メールアドレス*/
tel_number varchar(13),/*電話番号*/
user_address varchar(50) not null,/*住所*/
regist_date datetime,/*登録日時*/
update_date datetime,/*更新日時*/
foreign key (user_id) references user_info(user_id));/*外部キー制約*/
/*カテゴリマスタテーブル*/
create table m_category(
id int not null primary key auto_increment,/*ID*/
category_id int unique not null,/*カテゴリID*/
category_name varchar(20) unique,/*カテゴリ名*/
category_description varchar(100),/*カテゴリ詳細*/
insert_date datetime not null,/*登録日時*/
update_date datetime);/*更新日時*/

set foreign_key_checks=1;/*外部キー制約を有効にする*/
/*ゲストユーザー*/
insert into user_info values
(1,"guest","guest","ゲスト","ユーザー","げすと","ゆーざー",0,"gest@email.com",0,0,now(),now()),
(2,"guest2","guest2","ゲスト2","ユーザー","げすと2","ゆーざー",0,"gest2@email.com",0,0,now(),now()),
(3,"guest3","guest3","ゲスト3","ユーザー","げすと3","ゆーざー",0,"gest3@email.com",0,0,now(),now()),
(4,"guest4","guest4","ゲスト4","ユーザー","げすと4","ゆーざー",0,"gest4@email.com",0,0,now(),now()),
(5,"guest5","guest5","ゲスト5","ユーザー","げすと5","ゆーざー",0,"gest5@email.com",0,0,now(),now()),
(6,"guest6","guest6","ゲスト6","ユーザー","げすと6","ゆーざー",0,"gest6@email.com",0,0,now(),now()),
(7,"guest7","guest7","ゲスト7","ユーザー","げすと7","ゆーざー",0,"gest7@email.com",0,0,now(),now()),
(8,"guest8","guest8","ゲスト8","ユーザー","げすと8","ゆーざー",0,"gest8@email.com",0,0,now(),now()),
(9,"guest9","guest9","ゲスト9","ユーザー","げすと9","ゆーざー",0,"gest9@email.com",0,0,now(),now()),
(10,"guest10","guest10","ゲスト10","ユーザー","げすと10","ゆーざー",0,"gest10@email.com",0,0,now(),now()),
(11,"guest11","guest11","ゲスト11","ユーザー","げすと11","ゆーざー",0,"gest11@email.com",0,0,now(),now()),
(12,"guest12","guest12","ゲスト12","ユーザー","げすと12","ゆーざー",0,"gest12@email.com",0,0,now(),now());

insert into m_category values
(1,1,"すべてのカテゴリー","本、家電、玩具、衣類・アクセサリーのすべてのカテゴリーが対象となります。",now(),now()),
(2,2,"本","本に関するカテゴリーが対象となります。",now(),now()),
(3,3,"家電","家電に関するカテゴリーが対象となります。",now(),now()),
(4,4,"玩具","玩具に関するカテゴリーが対象となります。",now(),now()),
(5,5,"衣類・アクセサリー","衣類・アクセサリーに関するカテゴリーが対象となります。",now(),now());

insert into product_info values
(1,1,"国語辞典","こくごじてん","日本語の語彙を説明した書物",2,3000,"./images","japanesedi.jpg",now(),"■■社",1,now(),now()),
(2,2,"小説","しょうせつ","物語が書かれている書物",2,500,"./images","novel.jpg",now(),"▲▲文庫",1,now(),now()),
(3,3,"雑誌","ざっし","定期的に出版される書物",2,800,"./images","zasshi.jpg",now(),"●●出版",1,now(),now()),
(4,4,"漫画","まんが","イラストと台詞で物語を表現した書物",2,600,"./images","manga.jpg",now(),"××社",1,now(),now()),
(5,5,"英和辞典","えいわじてん","英語の語彙を日本語で説明した書物",2,2000,"./images","englishdi.jpg",now(),"◆◆社",1,now(),now()),
(6,6,"洗濯機","せんたくき","衣類等を洗濯する機械",3,80000,"./images","sentakuki.jpg",now(),"TOSHIPA",1,now(),now()),
(7,7,"掃除機","そうじき","掃除をする機械",3,50000,"./images","creaner.jpg",now(),"Tyson",1,now(),now()),
(8,8,"パソコン","ぱそこん","便利な機器",3,100000,"./images","pc.jpg",now(),"ringo",1,now(),now()),
(9,9,"テレビ","てれび","様々な番組を見ることができる機器",3,90000,"./images","tv.jpg",now(),"SHARPE",1,now(),now()),
(10,10,"電子レンジ","でんしれんじ","食品を温める機器",3,30000,"./images","dneshirenzi.jpg",now(),"Banasonic",1,now(),now()),
(11,11,"けん玉","けんだま","懐かしいおもちゃ",4,800,"./images","kendama.jpg",now(),"○○商店",1,now(),now()),
(12,12,"ヨーヨー","よーよー","おもちゃ",4,500,"./images","yo-yo-.jpg",now(),"▲▲商店",1,now(),now()),
(13,13,"つみ木","つみき","赤ちゃんも遊べるおもちゃ",4,1500,"./images","tumiki.jpg",now(),"○○商店",1,now(),now()),
(14,14,"竹とんぼ","たけとんぼ","懐かしいおもちゃ",4,300,"./images","taketonbo2.jpg",now(),"▲▲商店",1,now(),now()),
(15,15,"バルーン","ばるーん","風船",4,600,"./images","huusen.jpg",now(),"○○商店",1,now(),now()),
(16,16,"ワンピース","わんぴーす","ワンピース",5,4000,"./images","onepiece.jpg",now(),"ウニクロ",1,now(),now()),
(17,17,"Tシャツ","てぃーしゃつ","Tシャツ",5,2000,"./images","tshirt.jpg",now(),"ウニクロ",1,now(),now()),
(18,18,"ズボン","ずぼん","ズボン",5,5000,"./images","zubon.jpg",now(),"ADWIN",1,now(),now()),
(19,19,"時計","とけい","時計",5,1000000,"./images","watch.jpg",now(),"OMEKA",1,now(),now()),
(20,20,"ネックレス","ねっくれす","ネックレス",5,20000,"./images","neckless.jpg",now(),"Diffany",1,now(),now())
;

insert into destination_info value
(1,"guest","インターノウス","テストユーザー","いんたーのうす","てすとゆーざー","internous@email.com","03-xxxx-xxxx","東京都千代田区●●１－１　ＫＹ三番町ビル１Ｆ",now(),now());
