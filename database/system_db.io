// Решение по распределенному хранению данных
// Replication:
// master-slave, async
// RF = 2
//
// Sharding - key-based:
// subscription - don't needed shardihg
// post - by user_id
// reaction - by post_id
// comment - by post_id
// geo - don't needed shardihg


Table subscr_db.subscription{
  subscription_id uuid [pk]
  user_id uuid [not null, note: 'subscribers Id', ref: > user_db.user.user_id]
  target_id uuid [not null, note: 'target-subscription Id', ref: > user_db.user.user_id]
  subscr_create_dttm timestamp 
}

Table user_db.user {
  user_id uuid
  nickname varchar (100)
  user_create_dttm timestamp
}

Table post_db.post {
  post_id integer [primary key]
  text varchar(10000) [note:'describe of post']
  photos varchar[] [note: 'array of photo URLs']
  user_id uuid [not null, note:'author of post', ref: > user_db.user.user_id]
  geo_id uuid [not null, note: 'id of location', ref: > geo_db.geo.geo_id]
  post_create_dttm timestamp
}

Table reaction_db.reaction {
  reaction_id uuid [primary key]
  user_id uuid [not null, note:'creater of reaction', ref: > user_db.user.user_id]
  post_id uuid [not null, ref: > post_db.post.post_id]
  react_create_dttm timestamp
}

Table reaction_db.reaction_value {
  post_id uuid [not null, unique, ref: - post_db.post.post_id]
  reaction_value integer [not null, default: 0]
  react_value_creat_dttm timestamp
  react_value_update_dttm timestamp
}

Table comment_db.comment {
  comment_id uuid [primary key]
  user_id uuid [not null, note:'author of comment', ref: > user_db.user.user_id]
  post_id uuid [not null, ref: > post_db.post.post_id]
  comment varchar(10000)
  comment_create_dttm timestamp
}

Table geo_db.geo {
  geo_id uuid [primary key]
  address_full varchar(1000) [not null]
  address_component json [not null, note:' {name: Россия , type: Страна} - разделение адреса по компонентам']
  geo_longitude geograthy [not null]
  geo_latitude geograthy [not null]
  geo_create_dttm timestamp
  }