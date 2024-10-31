import React, { useState } from 'react';
import { CheckCircle2, XCircle, AlertCircle, AlertTriangle, X } from 'lucide-react';

export default function MinimalNotification() {
  const [notifications, setNotifications] = useState([]);

  const getIcon = (type) => {
    const icons = {
      success: <CheckCircle2 size={16} />,
      error: <XCircle size={16} />,
      info: <AlertCircle size={16} />,
      warning: <AlertTriangle size={16} />
    };
    return icons[type];
  };

  const getColors = (type) => {
    const colors = {
      success: 'border-l-emerald-400 text-emerald-400',
      error: 'border-l-red-400 text-red-400',
      info: 'border-l-blue-400 text-blue-400',
      warning: 'border-l-amber-400 text-amber-400'
    };
    return colors[type];
  };

  const getPositionClasses = (position, align) => {
    const positions = {
      TOP_LEFT: 'top-4 left-4',
      TOP_RIGHT: 'top-4 right-4',
      TOP_CENTER: 'top-4 left-1/2 -translate-x-1/2',
      MIDDLE_LEFT: 'top-1/2 -translate-y-1/2 left-4',
      MIDDLE_RIGHT: 'top-1/2 -translate-y-1/2 right-4',
      MIDDLE_CENTER: 'top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2',
      BOTTOM_LEFT: 'bottom-4 left-4',
      BOTTOM_RIGHT: 'bottom-4 right-4',
      BOTTOM_CENTER: 'bottom-4 left-1/2 -translate-x-1/2'
    };

    const alignments = {
      left: 'text-left',
      right: 'text-right',
      center: 'text-center'
    };

    return `${positions[position] || positions.TOP_RIGHT} ${alignments[align] || 'text-left'}`;
  };

  const removeNotification = (id) => {
    setNotifications(notifications.filter(notif => notif.id !== id));
    // Send callback to Lua
    fetch(`https://${GetParentResourceName()}/notificationClosed`, {
      method: 'POST',
      body: JSON.stringify({ id })
    });
  };

  // Listen for messages from Lua
  window.addEventListener('message', (event) => {
    const { action, notification, id } = event.data;

    if (action === 'addNotification') {
      setNotifications(current => [...current, notification]);
    } else if (action === 'removeNotification') {
      setNotifications(current => current.filter(notif => notif.id !== id));
    }
  });

  return (
    <>
      {notifications.map((notification) => (
        <div
          key={notification.id}
          className={`
            fixed pointer-events-none
            ${getPositionClasses(notification.position, notification.align)}
          `}
        >
          <div
            className={`
              w-80 bg-gray-900/80 backdrop-blur-[2px]
              border-l-2 pointer-events-auto
              transform transition-all duration-200
              hover:translate-x-[-4px]
              ${getColors(notification.type)}
            `}
          >
            <div className="p-3 flex items-center gap-3">
              <span className={getColors(notification.type)}>
                {getIcon(notification.type)}
              </span>
              
              <div className="flex-1 min-w-0">
                <p className="text-sm text-gray-100">
                  {notification.message}
                </p>
                <p className="text-xs text-gray-500 mt-0.5">
                  {notification.time}
                </p>
              </div>
              <button 
                onClick={() => removeNotification(notification.id)}
                className="p-1 rounded hover:bg-gray-800/50 transition-colors duration-200"
              >
                <X size={14} className="text-gray-400" />
              </button>
            </div>
          </div>
        </div>
      ))}
    </>
  );
}