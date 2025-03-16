
reaction_value
  post_id:
  {
  reaction_value integer [not null, default: 0]
  react_value_update_dttm timestamp
  }


popular_geo 
  geo:
  [{
  address_full string [not null]
  geo_longitude number [not null]
  geo_latitude number [not null]
  address_component[
    {
    name string [not null]
    type string [not null]
    }
  count_posts integer
  }
  ...
  ]           

personal_posts 
  user_id: [
    {
    post_id integer 
    text string(10000) [note:'describe of post']
    body text [note: 'Content of the post']
    photos varchar[] [note: 'array of photo URLs']
    user_id string [not null, note: 'author of post']
    geo_id uuid [not null, note: 'id of location']
    post_create_dttm timestamp
    }
    ...
  ]

feed_posts 
  user_id: [
    {
    post_id integer 
    text string(10000) [note:'describe of post']
    body text [note: 'Content of the post']
    photos varchar[] [note: 'array of photo URLs']
    user_id string [not null, note: 'author of post']
    geo_id uuid [not null, note: 'id of location']
    post_create_dttm timestamp
    }
    ...
  ]