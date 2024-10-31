import React, { useState } from 'react';
import { CheckCircle, AlertCircle, Info, AlertTriangle, X, CheckCircle2 } from 'lucide-react';

export default function NotificationSystem() {
  const [notifications, setNotifications] = useState([]);
  const [style, setStyle] = useState('minimal');

  // Group notifications by position
  const groupedNotifications = notifications.reduce((acc, notification) => {
    const position = notification.position || 'TOP_RIGHT';
    if (!acc[position]) {
      acc[position] = [];
    }
    acc[position].push(notification);
    return acc;
  }, {});

  const getMinimalIcon = (type) => {
    const icons = {
      success: <CheckCircle2 size={16} />,
      error: <AlertCircle size={16} />,
      info: <AlertCircle size={16} />,
      warning: <AlertTriangle size={16} />
    };
    return icons[type];
  };

  const getAdvancedIcon = (type) => {
    const icons = {
      success: <CheckCircle className="text-emerald-400" size={20} />,
      error: <AlertCircle className="text-red-400" size={20} />,
      info: <Info className="text-blue-400" size={20} />,
      warning: <AlertTriangle className="text-amber-400" size={20} />
    };
    return icons[type];
  };

  const getMinimalColors = (type) => {
    const colors = {
      success: 'border-l-emerald-400 text-emerald-400',
      error: 'border-l-red-400 text-red-400',
      info: 'border-l-blue-400 text-blue-400',
      warning: 'border-l-amber-400 text-amber-400'
    };
    return colors[type];
  };

  const getAdvancedColors = (type) => {
    const colors = {
      success: 'from-emerald-400/10 to-emerald-400/5 border-emerald-400/20',
      error: 'from-red-400/10 to-red-400/5 border-red-400/20',
      info: 'from-blue-400/10 to-blue-400/5 border-blue-400/20',
      warning: 'from-amber-400/10 to-amber-400/5 border-amber-400/20'
    };
    return colors[type];
  };

  const removeNotification = (id) => {
    setNotifications(prev => prev.filter(notif => notif.id !== id));
    fetch(`https://${GetParentResourceName()}/notificationClosed`, {
      method: 'POST',
      body: JSON.stringify({ id })
    });
  };

  // Single event listener for messages
  React.useEffect(() => {
    const handleMessage = (event) => {
      const { action, notification, id, config } = event.data;

      if (action === 'setStyle') {
        setStyle(config.style);
      } else if (action === 'addNotification') {
        setNotifications(prev => [...prev, {
          ...notification,
          time: 'Just now'
        }]);
      } else if (action === 'removeNotification') {
        setNotifications(prev => prev.filter(notif => notif.id !== id));
      }
    };

    window.addEventListener('message', handleMessage);
    return () => window.removeEventListener('message', handleMessage);
  }, []);

  const MinimalStyle = ({ notification }) => (
    <div
      className={`
        w-80 bg-gray-900/80 backdrop-blur-[2px]
        border-l-2 pointer-events-auto
        transform transition-all duration-200
        hover:translate-x-[-4px]
        ${getMinimalColors(notification.type)}
      `}
    >
      <div className="p-3 flex items-center gap-3">
        <span className={getMinimalColors(notification.type)}>
          {getMinimalIcon(notification.type)}
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
  );

  const AdvancedStyle = ({ notification }) => (
    <div
      className={`
        w-96 backdrop-blur-sm
        transform transition-all duration-300 ease-out
        hover:translate-x-[-4px]
      `}
    >
      <div className={`
        p-4 rounded border bg-gradient-to-r pointer-events-auto
        ${getAdvancedColors(notification.type)}
      `}>
        <div className="flex items-start gap-4">
          <div className="p-2 rounded-lg bg-gray-900/50">
            {getAdvancedIcon(notification.type)}
          </div>
          
          <div className="flex-1 min-w-0">
            <div className="flex items-center justify-between gap-2">
              <p className="font-medium text-white">
                {notification.title}
              </p>
              <button 
                onClick={() => removeNotification(notification.id)}
                className="p-1 rounded hover:bg-gray-900/50 transition-colors duration-200"
              >
                <X size={14} className="text-gray-400" />
              </button>
            </div>
            <p className="text-sm text-gray-300 mt-1">
              {notification.message}
            </p>
            <p className="text-xs text-gray-400 mt-2">
              {notification.time}
            </p>
          </div>
        </div>
      </div>
    </div>
  );

  const getPositionClasses = (position) => ({
    TOP_LEFT: 'top-4 left-4',
    TOP_RIGHT: 'top-4 right-4',
    TOP_CENTER: 'top-4 left-1/2 -translate-x-1/2',
    MIDDLE_LEFT: 'top-1/2 -translate-y-1/2 left-4',
    MIDDLE_RIGHT: 'top-1/2 -translate-y-1/2 right-4',
    MIDDLE_CENTER: 'top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2',
    BOTTOM_LEFT: 'bottom-4 left-4',
    BOTTOM_RIGHT: 'bottom-4 right-4',
    BOTTOM_CENTER: 'bottom-4 left-1/2 -translate-x-1/2'
  }[position] || 'top-4 right-4');

  return (
    <>
      {/* Render notifications grouped by position */}
      {Object.entries(groupedNotifications).map(([position, positionNotifications]) => (
        <div
          key={position}
          className={`fixed pointer-events-none flex flex-col gap-2 ${getPositionClasses(position)}`}
        >
          {positionNotifications.map((notification) => (
            style === 'minimal' ? 
              <MinimalStyle key={notification.id} notification={notification} /> :
              <AdvancedStyle key={notification.id} notification={notification} />
          ))}
        </div>
      ))}
      
      {/* Notification counter */}
      {notifications.length > 0 && (
        <div className="
          fixed bottom-4 right-4 px-3 py-1.5
          bg-gray-900/90 backdrop-blur-[2px]
          border-l-2 border-l-teal-400
          text-xs text-gray-300
          pointer-events-auto
        ">
          {notifications.length} notifications
        </div>
      )}
    </>
  );
}