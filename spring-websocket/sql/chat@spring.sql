--====================================================================
-- @spring 계정
--====================================================================
--chat_room
--chat_member
--chat_log
--chat_view : spring계정에 create view 권한부여할 것.
--seq_chat : chat_room, chat_member, chat_log 의 id 컬럼값 부여(공용)

create table chat_room(
    id number,
    chat_id char(20) not null,
    reg_date date default sysdate,
    enabled char(1) default 'Y',
    constraint pk_chat_room primary key(id),
    constraint ck_chat_room_enabled check(enabled in ('Y','N'))
);

create table chat_member (
    id number,
    chat_room_id number not null,
    member_id varchar2(50) not null,    -- member.member_id 혹은 비회원 session id (member.member_id 에 fk를 걸지 않는다.)
    last_check number default 0,        -- member의 채팅방 마지막 확인 시각
    reg_date date default sysdate,      -- 채팅방 입장
    exp_date date,                      -- 채팅방 퇴장 
    enabled char(1) default 'Y',
    constraint pk_chat_member primary key(id),
    constraint fk_chat_member_chat_room foreign key(chat_room_id) references chat_room(id) on delete cascade,
    constraint uq_chat_room_member unique(chat_room_id, member_id),
    constraint ck_chat_member_enabled check(enabled in ('Y','N'))  
);

create table chat_log (
    id number,
    chat_room_id number,
    member_id varchar2(50) not null,
    msg varchar2(2000), 
    time number not null,
    enabled char(1) default 'Y',
    constraint pk_chat_log primary key(id),
    constraint fk_chat_log_chat_member foreign key(chat_room_id,member_id) references chat_member(chat_room_id,member_id) on delete cascade,
    constraint ck_chat_log_enabled check(enabled in ('Y','N'))  
);

--chat_room, chat_member 조인한 chat_view 생성
create or replace view 
    chat_view
as
select 
    cr.id cr_id,
    chat_id,
    cr.reg_date cr_reg_date,
    cr.enabled cr_enabled,
    cm.id cm_id,
    member_id,
    last_check,
    cm.reg_date cm_reg_date,
    cm.exp_date exp_date,
    cm.enabled cm_enabled
from 
    chat_room cr
  join 
    chat_member cm
      on cr.id = cm.chat_room_id;
      
create sequence seq_chat;

--chat_view는 updatable join view인가.
--key_preserved_table은 join시에 해당테이블의 pk컬럼이 view에서도 pk로 사용되는 테이블이다.
--key_preserved_table인 chat_member에 한해서 insert/update/delete 가능하다.
--non_key_preserved_table인 chat_room에 한해서는 dml이 불가하다.
insert into
    chat_view 
        (cr_id,chat_id, cm_id, member_id)
values(
    1,'chat123456789',1,'member_id'
);--SQL Error: ORA-01779: cannot modify a column which maps to a non key-preserved table




--==============================================================
-- query test
--==============================================================
--updatable column 조회
select 
    *
from 
    user_updatable_columns
where 
    table_name = 'CHAT_VIEW';

    
--findChatIdByMemberId 
select 
    chat_id
from 
    chat_view
where
    cr_enabled = 'Y'
  and 
    cm_enabled = 'Y'
  and
    member_id = 'tuuk';
    
--selectOneChatId    
select 
    chat_id
from
    chat_view
where
    chat_id = 'chatd78kr1Sj88wN4Z8';

--insertChatRoom
insert into
    chat_room 
        (id, chat_id)
values(
    seq_chat.nextval, 
    'abcde'
);


--insertChatMember
insert into
    chat_member
        (id, chat_room_id, member_id)

values(
    seq_chat.nextval,
    2,
    'honggd'
);
    
--insertChatLog
insert into 
    chat_log 
        (id, chat_room_id, member_id, msg, time)
values(
    seq_chat.nextval, 
    2,
    'honggd',
    'testtestets',
    1527530455
);

--findRecentList
--lastCheck 구현전
select 
    *
from (
    select 
        id,
        cv.cr_id,
        cv.chat_id,
        (select member_id from chat_view where cr_id = cl.chat_room_id and member_id != 'admin') member_id,
        cl.msg,
        cl.time,
        0 cnt,
        rank() over(partition by cl.chat_room_id order by time desc) rank 
    from 
        chat_log cl
      left join
        chat_view cv
          on cl.chat_room_id = cv.cr_id and cl.member_id = cv.member_id
    order by
        time desc
    )
where 
    rank = 1
order by
    time desc;


--lastCheck 구현후
select 
    *
from (
    select 
        id,
        cv.cr_id,
        cv.chat_id,
        (select member_id from chat_view where cr_id = cl.chat_room_id and member_id != 'admin') member_id,
        cl.msg,
        cl.time,
        count(*) over(partition by cl.chat_room_id,cl.member_id) cnt,
        rank() over(partition by cl.chat_room_id order by time desc) rank 
    from 
        chat_log cl
      left join
        chat_view cv
          on cl.chat_room_id = cv.cr_id and cl.member_id = cv.member_id
    where 
        time > (select last_check from chat_view where cr_id = cl.chat_room_id and member_id = 'admin')
    order by
        time desc
    )
where 
    rank = 1
union all 
select 
    *
from (
    select 
        id,
        cv.cr_id,
        cv.chat_id,
        (select member_id from chat_view where cr_id = cl.chat_room_id and member_id != 'admin') member_id,
        cl.msg,
        cl.time,
        0 cnt,
        rank() over(partition by cl.chat_room_id order by time desc) rank 
    from 
        chat_log cl
      left join
        chat_view cv
          on cl.chat_room_id = cv.cr_id and cl.member_id = cv.member_id
    order by 
        time desc
    ) A
where 
    rank = 1 
  and 
    time <= (select last_check from chat_view where cr_id = A.cr_id and member_id = 'admin');


--findChatListByChatId
select 
    * 
from 
    chat_log
where 
    chat_room_id = (select id from chat_room where chat_id = 'chatw33XVnbE8FM7MvO5')
order by 
    id;

--updateLastCheck
update 
    chat_member
set 
    last_check =  123
where 
    chat_room_id = (select id from chat_room where chat_id = 'chatw33XVnbE8FM7MvO5')
  and 
    member_id = 'tuuk';

--=============================================================
select * from chat_log;
select * from chat_room;
select * from chat_member;
select * from member;
