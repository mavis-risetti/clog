(defpackage #:clog-user
  (:use #:cl #:clog)
  (:export start-demo))

(in-package :clog-user)

(defvar *global-list-box-hash* (make-hash-table :test 'equalp)
  "Username to update function")

(defun send-message (user msg)
  (maphash (lambda (key value)
	     (create-span value :content (format nil "~A : ~A<br>" user msg))
	     (setf (scroll-top value) (scroll-height value)))
	   *global-list-box-hash*))

(defun on-new-window (body)
  (load-css (html-document body) "/css/w3.css")
  (setf (title (html-document body)) "CLOG Chat")
  
  (let* ((backdrop   (create-div body :class "w3-container w3-cyan"))
	 
	 (form-box   (create-div backdrop :class "w3-container w3-white"))
	 
	 (start-form (create-form form-box))
	 (caption    (create-section start-form :h3 :content "Sign In"))
	 (name-entry (create-form-element start-form :input :label
					  (create-label start-form :content "Chat Handle:")))
	 (ok-button  (create-button start-form :content "OK"))
	 (tmp        (create-p start-form))

	 (chat-box   (create-form form-box))
	 (tmp        (create-br chat-box))
	 (messages   (create-div chat-box))
	 (tmp        (create-br chat-box))
	 (out-entry  (create-form-element chat-box :input))
	 (out-ok     (create-button chat-box :content "OK"))
	 (tmp        (create-p chat-box))
	 (user-name))

    (setf (hiddenp chat-box) t)
    
    (setf (background-color backdrop) :blue)
    (setf (height backdrop) "100vh")
    (setf (display backdrop) :flex)
    (setf (justify-content backdrop) :center)
    (setf (align-items backdrop) :center)

    (setf (background-color form-box) :white)
    (setf (display backdrop) :flex)
    (setf (justify-content backdrop) :center)
    (setf (width form-box) "60vh")

    (setf (height messages) "70vh")
    (setf (width messages) "100%")
    (set-border messages :thin :solid :black)
    (setf (overflow messages) :scroll)
    
    (set-on-click ok-button
		  (lambda (obj)
		    (setf (hiddenp start-form) t)
		    (setf user-name (value name-entry))
		    (setf (gethash user-name *global-list-box-hash*) messages)
		    (setf (hiddenp chat-box) nil)))

    (set-on-click out-ok
		  (lambda (obj)
		    (send-message user-name (value out-entry))
		    (setf (value out-entry) "")))

    (run body)
    (remhash user-name *global-list-box-hash*)))

(defun start-demo ()
  "Start demo."

  (initialize #'on-new-window)
  (open-browser))
