# System Design социальной сети для путешественников для курса по System Design

## Функциональные требования
1.	Бесконечная личная лента постов
2.	Публикация/удаление постов в личной ленте:
    - С фото
    - С текстом
    - С указанием геометки места путешествия
3.	Просмотр личной ленты постов 
4.	Просмотр ленты пользователя, основанных на подписках в обратном хронологическом порядке
5.	Просмотр ленты других путешественников
6.	Простановка оценки (like) посту другого пользователя
7.	Написание комментария к посту другого пользователя
8.	Поддержка подписки на других пользователей
9.	Поддержка поиска популярных мест для путешествий среди пользователей соц сети и просмотр постов с этих мест

## Нефункциональные требования
1.	Сезонность есть – в летние месяцы нагрузки больше в 1,5 раза (потребуется выделение ресурсов на этот период)
2.	DAO 10 000 000
3.	Аудитория стран СНГ
4.	Кросс-девайсная синхронизация (мобильная и веб-версия системы)
5.	Хранение данных пользователей и постов постоянное
6.	Пользовательская активность:
    - В среднем каждый пользователь публикует - 1 пост в сутки
    - В среднем каждый пользователь дает оценку 3 постам в сутки
    - В среднем каждый пользователь пишет 2 комментария в сутки
    - В среднем каждый пользователь просматривает личную ленту - 1 раз в сутки 
    - В среднем каждый пользователь просматривает ленту, основанную на подписках - 5 раз в сутки
    - В среднем каждый пользователь просматривает ленту других пользователей - 3 раза в сутки
    - В среднем каждый пользователь осуществляет поиск популярных мест 3 раза в сутки
    - В среднем каждый пользователь просматривает посты по популярному месту путешествия 2 раза в сутки
    - В среднем каждый пользователь просматривает комментарии под постом 2 раза в сутки
7.	Ограничения:
    - Пользователь может вносить не более 100 постов в сутки
    - Пост может содержать до 5 фотографий
    - Фотография не может весить больше 500 Kb
    - Текст поста не может превышать 10 000 символов
    - Текст комментария не может превышать 10 000 символов
    - Геометка может быть только 1
8.	Время обработки:
    - Создание 1 поста – 1 секунда
    - Создание оценки – 1 секунда
    - Создание комментария 1 секунда
    - Просмотр личной ленты пользователя\ленты другого пользователя\ленты, основанной на подписках – 2 секунды
    - Поиск популярных мест для путешествий среди пользователей соц сети – 2 секунды
    - Просмотр списка постов по определенному популярному месту путешествия – 2 секунды

## Оценка нагрузки
### RPS
**RPS-write**

All_write_RPS:

    10 000 000 * (1post + 3 react + 2 comment) /86 400= 80 000 000 / 86 400 ~ 700 RPS

RPS_write (Post): 

    10 000 000* 1 post /86400 ~ 120 RPS

RPS_write (Reaction): 

    10 000 000* 3 react /86400 ~ 350 RPS

RPS_write (Comment):

    10 000 000*2 comment /86400 ~ 230 RPS

**RPS-read**

All_reed_RPS: 

    10 000 000 (1 pers_feed +5 follow_feed + 3 another_feed + 3 search_location + 3posts_location) / 86400 ~ 1740 RPS
 
RPS_reed (Posts_feed):

    RPS_pers_feed:  10 000 000* 1 pers_feed /86400 ~ 120 RPS 
    
    RPS_follow_feed: 10 000 000* 5 follow_feed /86400 ~ 580 RPS
    
    RPS_another_feed: 10 000 000*3 another_feed /86400 ~ 350 RPS
    
    RPS_Posts_feed = 120 + 580 + 350 =1050 RPS

RPS_reed (Search):

    RPS_search_location: 10 000 000*3 search_location /86400 ~ 350 RPS
    
    RPS_posts_location: 10 000 000*3 posts_location /86400 ~ 350 RPS
    
    RPS_Search = 350 +350 = 700 RPS

RPS_reed (Comment): (viewing comments under a post)

    10 000 000 * 2 view_comment /86400  ~ 230 RPS
    

### Traffic

**Traffic-write:**

**Post_weight:**
   
     Post_weight_meta = 20 Kb+1Kb +1 Kb+ 1 Kb ~ 25 Kb
     Post_weight_media = 2500Kb
     
Post fields:
  1.	Describe: 10 000 symbol ~ 20 000 B ~ 20 Kb
  2.	Photo: 5* 500 Kb = 2500 Kb
  3.	GEO_name: 200 symbol~400 B ~ 1 Kb
  4.	Id -16 B
  5.	Rec_create_dttm-16 B~ 1 Kb
  6.	User_id-16 B ~ 1 Kb

Traffic_write_meta (Post):

    120RPS * 25 Kb ~ 3 Mb/sec
     
Traffic_write_media (Post):

    120RPS * 2500 Kb ~ 300 Mb/sec

     
**Reaction_weight:**  ```5*1 Kb = 5Kb ```

Reaction fields:
  1.	Id - 16 B~ 1 Kb
  2.	Post_id - 16 B~ 1 Kb
  3.	User_id - 16 B~ 1 Kb
  4.	Rec_create_dttm - 16 B~ 1 Kb
  5.	Weight  - 16 B~ 1 Kb

Traffic_write (Reaction):

    350RPS * 5Kb = 1750 Kb /sec ~ 2 Mb/sec
  
**Comment_weight:**  ```25 Kb ```

Comment fields:
  1.	Id - 16 B~ 1 Kb
  2.	Post_id - 16 B~ 1 Kb
  3.	User_id - 16 B~ 1 Kb
  4.	Comment - 10 000 symbol ~ 20 000 B ~ 20 Kb
  5.	Rec_create_dttm-16 B~ 1 Kb

Traffic_write (Comment):

    230 RPS * 25 Kb = 5750 Kb/sec ~ 6 Mb/sec

------------------
    
**Traffic-read:**

Traffic_reed_meta (Posts_feed): 

    1050 RPS * (25 Kb) * 20 (pagination) ~ 525 000 Kb/sec ~ 525 Mb/sec

Traffic_reed_media (Posts_feed): 

    1050 RPS * (2500 Kb) * 20 (pagination) ~ 52 500 Mb/sec
    
Traffic_reed (Search) ```~ 21 000 Mb/sec```
  - Traffic_search_location: 350 RPS * 1Kb (GEO_name) = 350 Kb/sec ~ 1 Mb/sec
  - Traffic_posts_location_meta: 350 RPS * (25 Kb) * 20 (pagination) = 175 000 Kb/sec = 175 Mb/sec
  - Traffic_posts_location_media: 350 RPS * (2500 Kb) * 20 (pagination) = 17 500 Mb/sec

Traffic_reed (Comment): 

    230 RPS * 25 Kb * 10 (pagination)  = 46000 Kb/sec ~ 50 Mb/sec

