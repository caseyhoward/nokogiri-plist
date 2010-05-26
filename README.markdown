5.to_s(:plist)

x = 5
def x.to_s
  PList.from_str(s)
end