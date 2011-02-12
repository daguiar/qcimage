from sqlalchemy import create_engine
from sqlalchemy.orm import (relationship, backref, sessionmaker, 
                            scoped_session)
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import (Table, Column, ForeignKey, Integer, String,
                        Boolean, Numeric, Text, DateTime)

import settings

engine = create_engine(settings.QCI_DB_STRING, pool_recycle=300)
Session = scoped_session(sessionmaker(bind=engine,autocommit=False,
                                      autoflush=False))
Base = declarative_base()
Base.query = Session.query_property()

##

class Serial:
    def flat(self):
        tmp = self.__dict__.copy()
        del tmp['_sa_instance_state']
        return tmp

    @classmethod
    def listing(self):
        return {"name": self.__name__, 
                "entries": [[user.username, 
                             user.id] for user in self.query.all()]}

## Utility Functions

def cleanup_session():
    Session.remove()   

class User(Base, Serial):
    __tablename__ = 'users'
    id = Column(Integer, primary_key=True)
    username = Column(String(255), unique=True, index=True)
    email = Column(String(255))
    passsword = Column(String(255))

    def __init__(self, username, email=None):
        self.username = username
        self.email = email

    @property
    def image(self):
        """ User.image:

        Returns the user's most recent revision

        """
        return list(self.revisions)[-1]

    def __repr__(self):
        return '<User {0}>'.format(self.username)

    
class Image(Base, Serial):
    __tablename__ = 'images'
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey('users.id'))
    path = Column(String(255))

    user = relationship(User, backref=backref('revisions', order_by=id))

    def __repr__(self):
        return '<Image {0}:{1}>'.format(self.username, self.id)

class Group(Base, Serial):
    __tablename__ = "groups"
    id = Column(Integer, primary_key=True)
    name = Column(String(255))

    def __repr__(self):
        return '<Node Group {0}>'.format(self.name)

    def __iter__(self):
        return self

    def __next__(self):
        for node in self.nodes:
            yield node
        raise StopIteration
    
class Node(Base, Serial):
    __tablename__ = "nodes"
    id = Column(Integer, primary_key=True)
    group_id = Column(Integer, ForeignKey('groups.id'))
    last_seen = Column(DateTime)
    name = Column(String(255))
    ip = Column(String(15))
    mac = Column(String(17))
    revision_id = Column(Integer, ForeignKey('images.id'))

    image = relationship(Image, backref=backref('nodes'))
    group = relationship(Group, backref=backref('nodes', order_by=id))

    def __init__(self, mac, ip):
        self.mac = mac
        self.ip = ip
    
    def __repr__(self):
        return '<Node {0}: {1}>'.format(self.name, self.ip)
    
    @property
    def user(self):
        return self.image.user if self.image else None

    
