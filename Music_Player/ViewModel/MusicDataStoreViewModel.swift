//
//  ViewModel.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/06.
//

//import Foundation
//
//@MainActor
//class MusicDataStoreViewModel: ObservableObject {
//    @Published var model = MusicDataStore.shared
//    
//    init(model: MusicDataStore) {
//        self.model = model
//    }
//    
//    var musicArray: [Music] {
//        get { return model.musicArray }
//        set { model.musicArray = newValue }
//    }
//    
//    var playlistArray: [playlist] {
//        get { return model.playlistArray }
//        set { model.playlistArray = newValue }
//    }
//    
//    public func getFile() async {
//        await model.getFile()
//    }
//    
//    public func sort(method: Int) {
//        model.sort(method: method)
//    }
//    
//    public func artistSelection() -> Array<Artist> {
//        return model.artistSelection()
//    }
//    
//    public func collectArtistMusic(artist: String) -> Array<Music> {
//        return model.collectArtistMusic(artist: artist)
//    }
//    
//    public func albumSelection() -> Array<Album> {
//        return model.albumSelection()
//    }
//    
//    public func collectAlbumMusic(album: String) -> Array<Music> {
//        return model.collectAlbumMusic(album: album)
//    }
//    
//    public func collectPlaylistMusic(playlistName: String) async -> Array<Music> {
//        return await model.collectPlaylistMusic(playlistName: playlistName)
//    }
//}
