
// Note: This code is derivative of the Pony runtime; see README.md for more details

#include "platform.h"

#ifndef pony_h
#define pony_h

#include <stdbool.h>

typedef void (*CreateActorFunc)(const char * actorUUID, const char * actorType, bool shouldBeProxy, int socketFD);
typedef void (*DestroyActorFunc)(const char * actorUUID);
typedef void (*MessageActorFunc)(const char * actorUUID, const char * behavior, void * payload, int payloadSize, int messageID, int replySocketFD);
typedef void (*RegisterActorsOnRootFunc)(int replySocketFD);

typedef void (*ReplyMessageFunc)(int messageID, void * payload, int payloadSize);

void pony_root(const char * address,
               int port,
               CreateActorFunc createActorFunc,
               ReplyMessageFunc replyMessageFunc);
void pony_node(const char * address,
               int port,
               bool automaticReconnect,
               CreateActorFunc createActorFunc,
               DestroyActorFunc destroyActorFunc,
               MessageActorFunc messageActorFunc,
               RegisterActorsOnRootFunc registerActorsOnRootFunc);

int pony_remote_nodes_count();
int pony_remote_core_count();

int pony_remote_actor_send_message_to_node(const char * actorUUID,
                                           const char * actorType,
                                           const char * behaviorType,
                                           int * nodeSocketFD,
                                           const void * bytes,
                                           int count);
void pony_remote_actor_send_message_to_root(int socketfd,
                                            int messageID,
                                            const void * bytes,
                                            int count);
void pony_send_remote_actor_to_root(int socketfd,
                                    const char * actorUUID,
                                    const char * actorType);

void pony_remote_destroy_actor(const char * actorUUID, int * nodeSocketFD);

bool pony_startup(void);
void pony_shutdown(void);

int pony_core_count();
int pony_e_core_count();
int pony_p_core_count();
bool pony_core_affinity_enabled();

void * pony_actor_create();

void pony_actor_send_message(void * actor, void * argumentPtr, void (*handleMessageFunc)(void * message));

void pony_actor_setpriority(void * actor, int priority);
int pony_actor_getpriority(void * actor);

void pony_actor_setbatchSize(void * actor, int batchSize);
int pony_actor_getbatchSize(void * actor);

void pony_actor_setcoreAffinity(void * actor, int coreAffinity);
int pony_actor_getcoreAffinity(void * actor);

void pony_actor_yield(void * actor);

int pony_actor_num_messages(void * actor);
void pony_actor_destroy(void * actor);

int pony_actors_load_balance(void * actorArray, int num_actors);

bool pony_actors_should_wait(int min_msgs, void * actorArray, int num_actors);
void pony_actors_wait(int min_msgs, void * actor, int num_actors);
void pony_actor_wait(int min_msgs, void * actor);

int pony_max_memory();

#endif
