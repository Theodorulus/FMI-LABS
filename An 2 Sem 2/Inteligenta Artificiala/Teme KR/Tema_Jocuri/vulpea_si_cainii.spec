# -*- mode: python ; coding: utf-8 -*-


block_cipher = None


a = Analysis(['vulpea_si_cainii.py'],
             pathex=['D:\\Theo\\Info\\FMI-LABS\\An 2, Sem 2\\Inteligenta Artificiala\\Teme KR\\Tema-Jocuri'],
             binaries=[],
             datas=[],
             hiddenimports=[],
             hookspath=[],
             runtime_hooks=[],
             excludes=[],
             win_no_prefer_redirects=False,
             win_private_assemblies=False,
             cipher=block_cipher,
             noarchive=False)
pyz = PYZ(a.pure, a.zipped_data,
             cipher=block_cipher)
exe = EXE(pyz,
          a.scripts,
          a.binaries,
          a.zipfiles,
          a.datas,
          [],
          name='vulpea_si_cainii',
          debug=False,
          bootloader_ignore_signals=False,
          strip=False,
          upx=True,
          upx_exclude=[],
          runtime_tmpdir=None,
          console=True )
