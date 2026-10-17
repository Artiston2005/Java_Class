package com.foodapp.websocket;

import javax.websocket.*;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArraySet;

@ServerEndpoint("/live/{role}/{id}")
public class LiveUpdateServer {

    // role -> id -> Set of Sessions
    private static final Map<String, Map<String, Set<Session>>> activeSessions = new ConcurrentHashMap<>();

    @OnOpen
    public void onOpen(Session session, @PathParam("role") String role, @PathParam("id") String id) {
        activeSessions
            .computeIfAbsent(role, k -> new ConcurrentHashMap<>())
            .computeIfAbsent(id, k -> new CopyOnWriteArraySet<>())
            .add(session);
        System.out.println("WebSocket Connected: " + role + " " + id + " (Session: " + session.getId() + ")");
    }

    @OnClose
    public void onClose(Session session, @PathParam("role") String role, @PathParam("id") String id) {
        Map<String, Set<Session>> roleSessions = activeSessions.get(role);
        if (roleSessions != null) {
            Set<Session> userSessions = roleSessions.get(id);
            if (userSessions != null) {
                userSessions.remove(session);
                if (userSessions.isEmpty()) {
                    roleSessions.remove(id);
                }
            }
        }
        System.out.println("WebSocket Disconnected: " + role + " " + id + " (Session: " + session.getId() + ")");
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        throwable.printStackTrace();
    }

    @OnMessage
    public void onMessage(String message, Session session) {
    }

    public static void broadcast(String role, String id, String jsonMessage) {
        Map<String, Set<Session>> roleSessions = activeSessions.get(role);
        if (roleSessions != null) {
            Set<Session> userSessions = roleSessions.get(id);
            if (userSessions != null) {
                for (Session session : userSessions) {
                    if (session.isOpen()) {
                        try {
                            session.getBasicRemote().sendText(jsonMessage);
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }
                }
            }
        }
    }
    
    public static void broadcastToRole(String role, String jsonMessage) {
        Map<String, Set<Session>> roleSessions = activeSessions.get(role);
        if (roleSessions != null) {
            for (Set<Session> userSessions : roleSessions.values()) {
                for (Session session : userSessions) {
                    if (session.isOpen()) {
                        try {
                            session.getBasicRemote().sendText(jsonMessage);
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }
                }
            }
        }
    }
}