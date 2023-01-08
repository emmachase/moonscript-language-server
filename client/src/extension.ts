/* --------------------------------------------------------------------------------------------
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 * ------------------------------------------------------------------------------------------ */

import * as path from 'path';
import * as vscode from 'vscode';
import { workspace, ExtensionContext } from 'vscode';

import {
	LanguageClient,
	LanguageClientOptions,
	ServerOptions,
	TransportKind
} from 'vscode-languageclient/node';

let client: LanguageClient;

function registerAST(context: ExtensionContext) {
	const astMap = new Map<string, string>()

	const onDidChangeEmitter = new vscode.EventEmitter<vscode.Uri>()
	vscode.workspace.registerTextDocumentContentProvider('moonscript-ast', {
		provideTextDocumentContent(uri: vscode.Uri): string {
			return astMap.get(uri.toString()) || 'Failed to load AST'
		},

		onDidChange: onDidChangeEmitter.event,
	})

	context.subscriptions.push(vscode.commands.registerCommand('moonscriptLanguageServer.showAST', () => {
		const openDocument = vscode.window.activeTextEditor?.document
		if (!openDocument) {
			vscode.window.showErrorMessage('No document open')
			return
		}

		client.sendRequest('textDocument/documentAST', { 
			textDocument: { 
				uri: openDocument.uri.toString(), 
				text: openDocument.getText() 
			},
			selection: vscode.window.activeTextEditor?.selection
		}).then(async (result: { tree: string, range: vscode.Range }) => {
			// Open a side-panel with the AST
			const uri = vscode.Uri.parse(`moonscript-ast://${openDocument.uri.path}.ast`)
			astMap.set(uri.toString(), result.tree)
			onDidChangeEmitter.fire(uri)
			const doc = await vscode.workspace.openTextDocument(uri)
			vscode.languages.setTextDocumentLanguage(doc, 'lua')
			const editor = await vscode.window.showTextDocument(doc, { 
				preview: true,
				viewColumn: vscode.ViewColumn.Beside
			})
			editor.selection = new vscode.Selection(result.range.start, result.range.end)
			editor.revealRange(result.range)
		})
	}))
}

export function activate(context: ExtensionContext) {
	// The server is implemented in node
	const serverModule = context.asAbsolutePath(
		path.join('server', 'server', 'server.lua')
	);

	const workingDirectory = context.asAbsolutePath(
		path.join('server')
	);

	console.log('serverModule', serverModule)

	// If the extension is launched in debug mode then the debug server options are used
	// Otherwise the run options are used
	// const serverOptions: ServerOptions = {
	// 	run: { module: serverModule, transport: TransportKind.ipc },
	// 	debug: {
	// 		module: serverModule,
	// 		transport: TransportKind.ipc,
	// 		options: { execArgv: ['--nolazy', '--inspect=6009'] }
	// 	}
	// };
	const serverOptions: ServerOptions = {
		command: 'luajit',
		transport: TransportKind.stdio,
		args: [serverModule],
		options: {
			cwd: workingDirectory
		}
	}

	// Options to control the language client
	const clientOptions: LanguageClientOptions = {
		// Register the server for plain text documents
		documentSelector: [{ scheme: 'file', language: 'moonscript' }],
		synchronize: {
			// Notify the server about file changes to '.clientrc files contained in the workspace
			fileEvents: workspace.createFileSystemWatcher('**/.clientrc')
		}
	};

	// Create the language client and start the client.
	client = new LanguageClient(
		'moonscriptLanguageServer',
		'Moonscript Language Server',
		serverOptions,
		clientOptions
	);

	// Start the client. This will also launch the server
	client.start();

	registerAST(context);
}

export function deactivate(): Thenable<void> | undefined {
	if (!client) {
		return undefined;
	}
	return client.stop();
}
