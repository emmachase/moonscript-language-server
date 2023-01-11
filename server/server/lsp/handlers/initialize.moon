-- interface InitializeParams extends WorkDoneProgressParams {
-- 	/**
-- 	 * The process Id of the parent process that started the server. Is null if
-- 	 * the process has not been started by another process. If the parent
-- 	 * process is not alive then the server should exit (see exit notification)
-- 	 * its process.
-- 	 */
-- 	processId: integer | null;

-- 	/**
-- 	 * Information about the client
-- 	 *
-- 	 * @since 3.15.0
-- 	 */
-- 	clientInfo?: {
-- 		/**
-- 		 * The name of the client as defined by the client.
-- 		 */
-- 		name: string;

-- 		/**
-- 		 * The client's version as defined by the client.
-- 		 */
-- 		version?: string;
-- 	};

-- 	/**
-- 	 * The locale the client is currently showing the user interface
-- 	 * in. This must not necessarily be the locale of the operating
-- 	 * system.
-- 	 *
-- 	 * Uses IETF language tags as the value's syntax
-- 	 * (See https://en.wikipedia.org/wiki/IETF_language_tag)
-- 	 *
-- 	 * @since 3.16.0
-- 	 */
-- 	locale?: string;

-- 	/**
-- 	 * User provided initialization options.
-- 	 */
-- 	initializationOptions?: LSPAny;

-- 	/**
-- 	 * The capabilities provided by the client (editor or tool)
-- 	 */
-- 	capabilities: ClientCapabilities;

-- 	/**
-- 	 * The initial trace setting. If omitted trace is disabled ('off').
-- 	 */
-- 	trace?: TraceValue;

-- 	/**
-- 	 * The workspace folders configured in the client when the server starts.
-- 	 * This property is only available if the client supports workspace folders.
-- 	 * It can be `null` if the client supports workspace folders but none are
-- 	 * configured.
-- 	 *
-- 	 * @since 3.6.0
-- 	 */
-- 	workspaceFolders?: WorkspaceFolder[] | null;
-- }

---@self ServerState
(params) =>
	@initialized = true
	{ 
		capabilities: {
			textDocumentSync: 1, -- Full Sync -- TODO: 2 for incremental
			documentSymbolProvider: true,
			definitionProvider: true,
			referencesProvider: true,
			-- renameProvider: true,
		}
		serverInfo: { name: "Moonscript Language Server" } -- TODO: version
	}
