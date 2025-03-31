Cache по сервисам

#### reaction_value: 
Счетчик лайков
```
  post_id:
  {
  reaction_value integer [not null, default: 0]
  react_value_update_dttm datetime
  }
```

#### popular_geo 
Хранение 10 популярных мест по соц сети.
```
  geo:
  [{
  geo_info: {
    geo_id uuid
    address_full string [not null]
    geo_longitude number [not null]
    geo_latitude number [not null]
    address_component[
      {
      name string [not null]
      type string [not null]
      }]
    }
  count_posts integer [not null]
  }
  ...
  ]           
```

### personal_posts 
Хранение личной ленты пользователей - последние 10 постов.
```
  user_id: [
    {
    post_id integer 
    text string(10000) [note:'describe of post']
    body text [note: 'Content of the post']
    photos string[] [note: 'array of photo URLs']
    user_id string [not null, note: 'author of post']
    geo_id uuid [not null, note: 'id of location']
    post_create_dttm datetime
    }
    ...
  ]
```

### feed_posts 
Хранение личной ленты пользователей - последние 20 постов.
```
  user_id: [
    {
    post_id integer 
    text string(10000) [note:'describe of post']
    body text [note: 'Content of the post']
    photos string[] [note: 'array of photo URLs']
    user_id string [not null, note: 'author of post']
    geo_id uuid [not null, note: 'id of location']
    post_create_dttm timestamp
    }
    ...
  ]
```

### user_info
Хранение информации о пользователе, использующейся в частых запросах на чтение.
```
  user_id:
    {
    nicname 
    }

```
